Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab1LOVXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:23:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61929 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:23:35 -0500
Date: Thu, 15 Dec 2011 13:23:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] cgroups: fix a css_set not found bug in
 cgroup_attach_proc
Message-ID: <20111215212329.GH32002@google.com>
References: <1323977803-5385-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323977803-5385-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:36:43AM -0800, Mandeep Singh Baines wrote:
> There is a BUG when migrating a PF_EXITING proc. Since css_set_prefetch()
> is not called for the PF_EXITING case, find_existing_css_set() will return
> NULL inside cgroup_task_migrate() causing a BUG.
> 
> This bug is easy to reproduce. Create a zombie and echo its pid to
> cgroup.procs.
> 
> $ cat zombie.c
> \#include <unistd.h>
> 
> int main()
> {
>   if (fork())
>       pause();
>   return 0;
> }
> $
> 
> We are hitting this bug pretty regularly on ChromeOS.
> 
> This bug is already fixed by Tejun Heo's cgroup patchset which is
> targetted for the next merge window:
> 
> https://lkml.org/lkml/2011/11/1/356
> 
> I've create a smaller patch here which just fixes this bug so that a
> fix can be merged into the current release and stable.

Looks safe to me.  Li?

Thanks.

-- 
tejun
