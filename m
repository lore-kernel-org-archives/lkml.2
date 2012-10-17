Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2JQALs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:11:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61840 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:11:47 -0400
Date: Tue, 16 Oct 2012 17:11:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ben Blum <bblum@andrew.cmu.edu>, Li Zefan <lizefan@huawei.com>
Subject: Re: [REGRESSION] cgroup: notify_on_release may not be triggered in
 some cases
Message-ID: <20121017001142.GN16166@google.com>
References: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 04, 2012 at 04:37:16PM +0900, Daisuke Nishimura wrote:
> notify_on_release must be triggered when the last process in a cgroup is
> move to another. But if the first(and only) process in a cgroup is moved to
> another, notify_on_release is not triggered.
> 
> 	# mkdir /cgroup/cpu/SRC
> 	# mkdir /cgroup/cpu/DST
> 	#
> 	# echo 1 >/cgroup/cpu/SRC/notify_on_release
> 	# echo 1 >/cgroup/cpu/DST/notify_on_release
> 	#
> 	# sleep 300 &
> 	[1] 8629
> 	#
> 	# echo 8629 >/cgroup/cpu/SRC/tasks
> 	# echo 8629 >/cgroup/cpu/DST/tasks
> 	-> notify_on_release for /SRC must be triggered at this point,
> 	   but it isn't.
> 
> This is because put_css_set() is called before setting CGRP_RELEASABLE
> in cgroup_task_migrate(), and is a regression introduce by the
> commit:74a1166d(cgroups: make procs file writable), which was merged
> into v3.0.
> 
> Cc: Ben Blum <bblum@andrew.cmu.edu>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: <stable@vger.kernel.org> # v3.0.x and later
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Applied to cgroup/for-3.7-fixes w/ Li's ack added.

Thanks!

-- 
tejun
