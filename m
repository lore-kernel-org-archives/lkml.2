Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1BQUPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:15:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28673 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1BQUPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:15:17 -0500
MIME-Version: 1.0
Message-ID: <f3e53a0d-0f27-469d-9376-3423e7b93148@default>
Date: Thu, 17 Feb 2011 12:14:49 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: PING? cleancache for 2.6.39 window?
References: <ec76a6ed-a1dc-4e8b-a4ac-1e72ab367d0f@default>
 <7b34b3ea-9436-4077-a35e-a5eaabd59813@default
 20101030120632.40345d0d.akpm@linux-foundation.org
 eaa7e0c3-ab9b-45e7-b396-7c59338e2ae2@default>
In-Reply-To: <eaa7e0c3-ab9b-45e7-b396-7c59338e2ae2@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D5D81CF.015C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Sent: Wednesday, January 19, 2011 9:42 AM
> To: Andrew Morton
> Cc: torvalds@linux-foundation.org; linux-kernel@vger.kernel.org;
> Christoph Hellwig; Jeremy Fitzhardinge
> Subject: RE: Ping? RE: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge
> window
> 
> > On Wed, 27 Oct 2010 11:37:47 -0700 (PDT) Dan Magenheimer
> > <dan.magenheimer@oracle.com> wrote:
> >
> > > Ping?  I hope you are still considering this.  If not or if
> > > there are any questions I can answer, please let me know.
> >
> > What's happened here is that the patchset has gone through its
> > iterations and a few people have commented and then after a while,
> > nobody had anything to say about the code so nobody said anything
> more.
> >
> > But silence doesn't mean acceptance - it just means that nobody had
> > anything to say.
> >
> > I think I looked at the earlier iterations, tried to understand the
> > point behind it all, made a few code suggestions and eventually tuned
> > out.  At that time (and hence at this time) I just cannot explain to
> > myself why we would want to merge this code.
> >
> > All new code is a cost/benefit decision.  The costs are pretty well
> > known: larger codebase, more code for us and our "customers" to
> > maintain and support, etc.  That the code pokes around in vfs and
> > various filesystems does increase those costs a little.
> >
> > But the extent of the benefits to our users aren't obvious to me.
> The
> > coe is still xen-specific, I believe?  If so, that immediately
> reduces
> > the benefit side by a large amount simply because of the reduced
> > audience.
> >
> > We did spend some time trying to get this wired up to zram so that
> the
> > feature would be potentially useful to *all* users, thereby setting
> the
> > usefulness multiplier back to 1.0.  But I don't recall that anything
> > came of this?
> >
> > I also don't know how useful the code is to its intended
> > micro-audience: xen users!
> >
> > So can we please revisit all this from the top level?  Jeremy, your
> > input would be valuable.  Christoph, I recall that you had technical
> > objections - can you please repeat those?
> >
> > It's the best I can do to kick this along, sorry.
> 
> Hi Andrew (and Linus) --
> 
> Time to re-open this conversation (for 2.6.39 merge window)?
> 
> Assuming GregKH approves kztmem as a staging driver, it should
> now set "the usefulness multiplier back to 1.0". Kztmem
> is a superset of Nitin's zcache and zram but more dynamic
> and is completely independent of Xen and virtualization.
> 
> See kztmem overview: https://lkml.org/lkml/2011/1/18/170
> 
> And I believe Christoph's technical objections have all been
> resolved.  See longer version of previous reply here:
> https://lkml.org/lkml/2010/10/30/226
> 
> So please reconsider cleancache!

Hi Andrew (and Linus) --

As you may have seen, gregkh has taken zcache into drivers/staging
for merging when the 2.6.39 window opens.  And zcache (which
works entirely in-kernel, no virtualization required) depends on
cleancache.

Cleancache and zcache are both in linux-next and, via linux-next,
in mmotm.  Last October, Linus said that he preferred cleancache
to merge via you (Andrew), not pulled from my git tree.  So:

1) Is cleancache finally now acceptable for merging in the
   upcoming 2.6.39 window? and
2) If so, is there anything else I need to do to ensure the
   merging of cleancache happens during the open window or will
   it all happen automagically (from my point of view) through
   your (Andrew's) normal open-window processes?

Sorry to be excessively persistent, but I don't want to miss
the 2.6.39 window due to my newbie-ness.  And I plan to be on
vacation for some time during March and would also like to ensure
I don't miss something *I* need to do before or during the
window.

Thanks,
Dan Magenheimer
