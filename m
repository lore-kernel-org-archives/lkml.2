Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2F0SWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:22:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50338 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2F0SWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:22:07 -0400
Date: Wed, 27 Jun 2012 11:22:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Paul Rolland <rol@as2917.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120627182202.GO15811@google.com>
References: <20120627195808.31714295@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627195808.31714295@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 27, 2012 at 07:58:08PM +0200, Paul Rolland wrote:
> Hello,
> 
> When I first booted my 3.5.0-rc3 config, I've some :
> Default I/O scheduler not found. Using noop.
> which surprised me. so, after the boot completed, I had a look at the
> system messages, and found :
> 
> ...
> io scheduler noop registered
> io scheduler deadline registered
> ------------[ cut here ]------------
> WARNING: at block/blk-cgroup.c:867 blkcg_policy_register+0xb5/0xc0()
> Hardware name: Vostro 1520
> Modules linked in:
> Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc3 #1
> Call Trace:
>  [<ffffffff8103a59a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81cafbed>] ? deadline_init+0x12/0x12
>  [<ffffffff8103a5e5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff8131a6f5>] blkcg_policy_register+0xb5/0xc0
>  [<ffffffff81cafc2f>] cfq_init+0x42/0x9f
>  [<ffffffff810001ba>] do_one_initcall+0x3a/0x160
>  [<ffffffff81c8ed08>] kernel_init+0x137/0x1bb
>  [<ffffffff81c8e5c5>] ? do_early_param+0x87/0x87
>  [<ffffffff8169e3d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81c8ebd1>] ? start_kernel+0x3b2/0x3b2
>  [<ffffffff8169e3d0>] ? gs_change+0xb/0xb
> ---[ end trace 82bc55f036371117 ]---

Can you please test the following branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-linus

Thanks.

-- 
tejun
