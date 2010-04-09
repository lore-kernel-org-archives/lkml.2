Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0DLKvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 06:51:18 -0400
Received: from UNIX11.ANDREW.CMU.EDU ([128.2.13.140]:51460 "EHLO
	unix11.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0DLKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 06:51:17 -0400
X-Greylist: delayed 3453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2010 06:51:17 EDT
Date: Thu, 8 Apr 2010 23:48:50 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       stable@kernel.org, Ben Blum <bblum@andrew.cmu.edu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix cgroup procs documentation
Message-ID: <20100409034850.GA596@unix11.andrew.cmu.edu>
References: <20100409121143.9610dc8f.kamezawa.hiroyu@jp.fujitsu.com>
 <4BBE9D58.2010602@cn.fujitsu.com>
 <20100409122001.60967001.kamezawa.hiroyu@jp.fujitsu.com>
 <4BBE9FAA.7000907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE9FAA.7000907@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 11:31:54AM +0800, Li Zefan wrote:
> Cc: Ben Blum
> 
> KAMEZAWA Hiroyuki wrote:
> > On Fri, 09 Apr 2010 11:22:00 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> KAMEZAWA Hiroyuki wrote:
> >>> 2.6.33's Documentation has the same wrong information. So, I CC'ed to stable.
> >>> If people believe this information, they'll usr cgroup.procs file and will
> >>> see cgroup doesn'w work as expected.
> >>> The patch itself is against -mm.
> >>>
> >>> ==
> >>> Writing to cgroup.procs is not supported now.
> >>>
> >>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>> ---
> >>>  Documentation/cgroups/cgroups.txt |    3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> Index: mmotm-temp/Documentation/cgroups/cgroups.txt
> >>> ===================================================================
> >>> --- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
> >>> +++ mmotm-temp/Documentation/cgroups/cgroups.txt
> >>> @@ -235,8 +235,7 @@ containing the following files describin
> >>>   - cgroup.procs: list of tgids in the cgroup.  This list is not
> >>>     guaranteed to be sorted or free of duplicate tgids, and userspace
> >>>     should sort/uniquify the list if this property is required.
> >>> -   Writing a tgid into this file moves all threads with that tgid into
> >>> -   this cgroup.
> >>> +   This is a read-only file, now.
> >> I think the better wording is "for now". :)
> >>
> > ok. BTW, does anyone work on this ?
> 
> It was Ben Blum, don't know if he's still working on it.

Aye. Oleg suggested a redesign of the last patch (putting the lock in
signal_struct instead of sighand_struct), but I haven't got time to work
on them now. Expect a revision in maybe two months...

> 
> > ==
> > 
> > Writing to cgroup.procs is not supported now.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> > ---
> >  Documentation/cgroups/cgroups.txt |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > Index: mmotm-temp/Documentation/cgroups/cgroups.txt
> > ===================================================================
> > --- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
> > +++ mmotm-temp/Documentation/cgroups/cgroups.txt
> > @@ -235,8 +235,7 @@ containing the following files describin
> >   - cgroup.procs: list of tgids in the cgroup.  This list is not
> >     guaranteed to be sorted or free of duplicate tgids, and userspace
> >     should sort/uniquify the list if this property is required.
> > -   Writing a tgid into this file moves all threads with that tgid into
> > -   this cgroup.
> > +   This is a read-only file, for now.
> >   - notify_on_release flag: run the release agent on exit?
> >   - release_agent: the path to use for release notifications (this file
> >     exists in the top cgroup only)
> > 
> > 
> > 
> 
