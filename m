Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1CHQVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:21:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1CHQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:21:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
Date: Tue, 8 Mar 2011 17:21:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <4D71668F.9050201@windriver.com> <201103072101.51326.arnd@arndb.de> <4D7542BF.1000007@windriver.com>
In-Reply-To: <4D7542BF.1000007@windriver.com>
MIME-Version: 1.0
Message-Id: <201103081721.44927.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:b3zrsGupuQu1oY6xKQRoMmZD+QcjMCLNWIdveMUx6pQ
 VLxxxXu+yQjb2wwCWq9FSygcTRaIlWwJ0KbDPEvvhw2z9PSG9h
 Lbn7guNsimya04ryPYLYcA6y03XkCxLSFGWUORO2kiPMQZ+ASF
 8+mvknoI+T1u/CG0ADcY0vEXf7fRerJfqaGT/p9hZBZvj3/96s
 WiLbF/nRIFOvXQV5uG5Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 March 2011, Paul Gortmaker wrote:
> On 11-03-07 03:01 PM, Arnd Bergmann wrote:
>
> > The problem with your method is that you have more work that depends
> > on the amount of changes in upstream than the work that depends on
> > the size of the patch set.
> 
> You might think so, but that really isn't the case at all.  The
> work involved is dictated only by the upstream subset that have
> an impact on the RT commits.   If there was a stream of a thousand
> contiguous upstream commits that did not break patch application,
> or the run time boot test, I'd not have to lift a finger.  Scripts
> applied the commits and ensured a continuous sanity.   If I was to
> do it again, I'd employ the exact same tactic in a heartbeat.

Fair enough, everyone has their own ways of dealing with this, I just
wanted to make sure that you are aware that there are other options
that people have used successfully.

Obviously, the number of conflicts is about the same, independent
of the way you partition the work. 
 
> This could make sense if they were real independent functionality
> boundaries that happened to give you this nice uniform division.
> But it is unlikely in practice. 

You have obviously worked a lot with these patches, so you have
a better understanding than me of how interrelated the patches
actually are. From a brief look at the contents and from the fact
that there already were independent branches in the 2.6.31-rt
kernel, my guess was that it is very possible to do a reasonable
split. Someone would have to seriously try it in order to know
for sure.

> And adding an artificial division
> may not work if there are implicit dependencies between the patches
> that a patch monkey like me might not see.  Another added cost is that
> I would now have 20 branches to individually compile and boot test.
> Maybe I could get away with more sparse testing, but maybe not.
>
> In any case, I really don't see what you are trying to propose here
> as being really all that fundamentally different -- you want to move
> a small set of patches over a bigger set of patches.  So you can say
> I'm moving a set of 20 odd patches, which were merged by Linus (and hence
> already known to be treatable as a whole self contained unit) over a larger
> set of some 500 RT patches.  Does it matter which group you call the
> big set and which one the small set?

The important difference IMHO is that when you have topic branches,
you can partition the work into hard and easy tasks at your own
choice, rather than having to go through all the merges that someone
else did in the same order:

* Half the branches will have little or no conflicts with the new
  upstream version, so you immediately reduce the amount of dull
  work by moving the branch up to the new upstream.
* Some particularly complex branches will have patches from only
  one or two people who know that code really well, so you can ask
  them to rebase the branch.
* A branch that has complex conflicts may turn out to be relevant
  only for a small group of users, e.g. a specific architecture,
  so you can defer rebasing it until someone else is interested
  in doing the work.
* Some feature from one branch (e.g. BKL or raw spinlocks) may
  have been solved upstream in a different way. When the branch
  is self-contained, you can immediately drop the branch instead
  of having to look through the 500 patches for possible
  interactions with the new upstream code.

Another very significant difference is that having topic branches
makes it much easier to merge code upstream. There may be some
branches that are just in need of a bit care to be acceptable to
upstream, and other branches contain the code that would need
a full redesign from scratch before anyone could seriously submit
them. In both cases, isolating the changes in a branch helps you
make forward progress towards upstream.

	Arnd
