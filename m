Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab2AYW3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:29:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2AYW3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:29:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [Announce] linux-pm tree changes
Date: Wed, 25 Jan 2012 23:32:48 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201201242356.04244.rjw@sisk.pl> <CAP=VYLo90FANL8tX5VPvL+3wKB0CDF3Ryz1Lsw6ECVpcT9nesQ@mail.gmail.com>
In-Reply-To: <CAP=VYLo90FANL8tX5VPvL+3wKB0CDF3Ryz1Lsw6ECVpcT9nesQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201252332.48993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 25, 2012, Paul Gortmaker wrote:
> On Tue, Jan 24, 2012 at 5:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > I'd like you to know some workflow changes regarding the linux-pm tree.
> >
> > Since it's now possible to create signed tags for Linus to pull from, I won't
> > need the 'pm-for-linus' branch any more and it's gone.  The 'pm-fixes' branch
> > is gone too and replaced by the 'fixes' branch (which currently contains the
> > same material as master).
> >
> > The idea is that the main development is going to happen in the 'master'
> > branch, which is not going to be rebased and the Linus' tree will be merged
> > into it from time to time (most of the time when the 'master' branch can be
> > fast-forwarded to it).  The 'fixes' branch will be used for pushing urgent
> 
> Not sure what you have in mind for "from time to time",

Something like once in a development cycle (right after a merge window),
but there may be exceptions.

> but random merges
> without a clear reason (i.e. "merge Linus to get access to new files X Y Z")
> are probably going to get you in hot water.

I know.

> Also, once you stack on your 1st PM commit onto your master, none of
> your future merges of Linus' tree will be fast forward.

Until Linus pulls from my tree.  Then I can do a fast forward and start over.

> Here is an
> example, where I simulate a local change, followed by "time to time"
> merges of Linus tree.  Note each creates a merge, not just the 1st one.
> 
> -----------------------------
> linux-head$git checkout -b crap v3.1
> Checking out files: 100% (17551/17551), done.
> Switched to a new branch 'crap'
> linux-head$echo foo > foo ; git add foo ; git commit -m '1st pm commit'
> [crap 1675da3] 1st pm commit
>  1 files changed, 1 insertions(+), 0 deletions(-)
>  create mode 100644 foo
> linux-head$git merge v3.2-rc1 2>&1 |grep 'Merge\|Fast'
> Merge made by recursive.
> linux-head$git merge v3.2-rc2 2>&1 |grep 'Merge\|Fast'
> Merge made by recursive.
> linux-head$git merge v3.2-rc3 2>&1 |grep 'Merge\|Fast'
> Merge made by recursive.
> linux-head$git show -m |head -n5
> commit 3cbd041875960361ffde72612afadc6c68e94654 (from
> 6f6028bdbbc63dc71b408da8976f154a2e6a70ee)
> Merge: 6f6028b caca6a0
> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date:   Wed Jan 25 13:45:55 2012 -0500
> linux-head$
> ----------------
> 
> Having lots of these kinds of pointless merge commits are
> what will most likely get you in hot water when you ask for
> it to be pulled.
> 
> Maybe I'm just misinterpreting what your plan is.

Please see above. :-)

Thanks,
Rafael
