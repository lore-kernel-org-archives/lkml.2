Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2K1OJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:09:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63519 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2K1OJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:09:05 -0500
Date: Wed, 28 Nov 2012 06:08:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] workqueue: exit rescuer_thread() as TASK_RUNNING
Message-ID: <20121128140859.GD15971@htj.dyndns.org>
References: <1354083438.4506.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354083438.4506.3.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 07:17:18AM +0100, Mike Galbraith wrote:
> 
> A rescue thread exiting TASK_INTERRUPTIBLE can lead to a task scheduling
> off, never to be seen again.  In the case where this occurred, an exiting
> thread hit reiserfs homebrew conditional resched while holding a mutex,
> bringing the box to it's knees.
> 
> PID: 18105  TASK: ffff8807fd412180  CPU: 5   COMMAND: "kdmflush"
>  #0 [ffff8808157e7670] schedule at ffffffff8143f489
>  #1 [ffff8808157e77b8] reiserfs_get_block at ffffffffa038ab2d [reiserfs]
>  #2 [ffff8808157e79a8] __block_write_begin at ffffffff8117fb14
>  #3 [ffff8808157e7a98] reiserfs_write_begin at ffffffffa0388695 [reiserfs]
>  #4 [ffff8808157e7ad8] generic_perform_write at ffffffff810ee9e2
>  #5 [ffff8808157e7b58] generic_file_buffered_write at ffffffff810eeb41
>  #6 [ffff8808157e7ba8] __generic_file_aio_write at ffffffff810f1a3a
>  #7 [ffff8808157e7c58] generic_file_aio_write at ffffffff810f1c88
>  #8 [ffff8808157e7cc8] do_sync_write at ffffffff8114f850
>  #9 [ffff8808157e7dd8] do_acct_process at ffffffff810a268f
> #10 [ffff8808157e7e78] acct_process at ffffffff810a27ba
> #11 [ffff8808157e7e98] do_exit at ffffffff8105e29a
> #12 [ffff8808157e7ee8] kthread at ffffffff8107afee
> #13 [ffff8808157e7f48] kernel_thread_helper at ffffffff8144a5c4
>     [exception RIP: kernel_thread_helper]
>     RIP: ffffffff8144a5c0  RSP: ffff8808157e7f58  RFLAGS: 00000202
>     RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000000000000
>     RDX: 0000000000000000  RSI: ffffffff8107af60  RDI: ffff8803ee491d18
>     RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000000
>     R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
>     R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> Cc: stable@vger.kernel.org

Applied to wq/for-3.8.  Thanks!

-- 
tejun
