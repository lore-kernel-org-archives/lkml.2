Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1LSRNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:13:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63552 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1LSRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:13:13 -0500
Date: Mon, 19 Dec 2011 09:13:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] cgroups: fix a css_set not found bug in
 cgroup_attach_proc
Message-ID: <20111219171307.GG24519@google.com>
References: <1323977803-5385-1-git-send-email-msb@chromium.org>
 <20111215212329.GH32002@google.com>
 <4EEAA923.5060104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEAA923.5060104@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 10:12:51AM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> > On Thu, Dec 15, 2011 at 11:36:43AM -0800, Mandeep Singh Baines wrote:
> >> There is a BUG when migrating a PF_EXITING proc. Since css_set_prefetch()
> >> is not called for the PF_EXITING case, find_existing_css_set() will return
> >> NULL inside cgroup_task_migrate() causing a BUG.
> >>
> >> This bug is easy to reproduce. Create a zombie and echo its pid to
> >> cgroup.procs.
> >>
> >> $ cat zombie.c
> >> \#include <unistd.h>
> >>
> >> int main()
> >> {
> >>   if (fork())
> >>       pause();
> >>   return 0;
> >> }
> >> $
> >>
> >> We are hitting this bug pretty regularly on ChromeOS.
> >>
> >> This bug is already fixed by Tejun Heo's cgroup patchset which is
> >> targetted for the next merge window:
> >>
> >> https://lkml.org/lkml/2011/11/1/356
> >>
> >> I've create a smaller patch here which just fixes this bug so that a
> >> fix can be merged into the current release and stable.
> > 
> > Looks safe to me.  Li?
> > 
> 
> It should be fine.
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Applied to cgroup/for-fixes-3.2.  Will push to Linus in a couple of
days.  It's already rc6 and a bit late tho.

Thank you.

-- 
tejun
