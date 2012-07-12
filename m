Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161326Ab2GLRFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:05:31 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63377 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143Ab2GLRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:05:26 -0400
Date: Thu, 12 Jul 2012 10:05:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
 worker_pool
Message-ID: <20120712170519.GA20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120712130648.GA19214@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712130648.GA19214@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Fengguang.

On Thu, Jul 12, 2012 at 09:06:48PM +0800, Fengguang Wu wrote:
> [    0.207977] WARNING: at /c/kernel-tests/mm/kernel/workqueue.c:1217 worker_enter_idle+0x2b8/0x32b()
> [    0.207977] Modules linked in:
> [    0.207977] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-08414-g9645fff #15
> [    0.207977] Call Trace:
> [    0.207977]  [<ffffffff81087189>] ? worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff810559d9>] warn_slowpath_common+0xae/0xdb
> [    0.207977]  [<ffffffff81055a2e>] warn_slowpath_null+0x28/0x31
> [    0.207977]  [<ffffffff81087189>] worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff81087222>] start_worker+0x26/0x42
> [    0.207977]  [<ffffffff81c8b261>] init_workqueues+0x2d2/0x59a
> [    0.207977]  [<ffffffff81c8af8f>] ? usermodehelper_init+0x8a/0x8a
> [    0.207977]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
> [    0.207977]  [<ffffffff81c6f650>] kernel_init+0x12e/0x3c1
> [    0.207977]  [<ffffffff814b9b74>] kernel_thread_helper+0x4/0x10
> [    0.207977]  [<ffffffff814b80b0>] ? retint_restore_args+0x13/0x13
> [    0.207977]  [<ffffffff81c6f522>] ? start_kernel+0x737/0x737
> [    0.207977]  [<ffffffff814b9b70>] ? gs_change+0x13/0x13

Yeah, I forgot to flip the WARN_ON_ONCE() condition so that it checks
nr_running before looking at pool->nr_running.  The warning is
spurious.  Will post fix soon.

Thanks.

-- 
tejun
