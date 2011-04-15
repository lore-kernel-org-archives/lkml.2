Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1DOTEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:04:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1DOTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:03:58 -0400
Subject: Re: mmotm 2011-04-14 - hangs during boot.
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <6325.1302893631@localhost>
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
	 <9629.1302879429@localhost>  <6325.1302893631@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 21:06:22 +0200
Message-ID: <1302894382.2035.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 14:53 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 15 Apr 2011 10:57:09 EDT, Valdis.Kletnieks@vt.edu said:
> > On Thu, 14 Apr 2011 15:08:47 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2011-04-14-15-08 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > This throws at least two complaints about lockdep on the way up.  I've had
> > several complete hangs as well last night during boot 
> 
> Caught them.  Not sure how the WARN_ON_ONCE it's hitting just before it hangs
> is related to the actual hang, but I'm betting it's the kernel's last plaintive
> cry for help before everything grinds to a halt.
> 
> First boot:

> [    3.859723] ------------[ cut here ]------------
> [    3.859859] WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0x168/0x19f()
> [    3.859984] Hardware name: Latitude E6500
> [    3.860089] Modules linked in:
> [    3.860308] Pid: 11, comm: kworker/1:0 Not tainted 2.6.39-rc3-mmotm0414 #1
> [    3.860428] Call Trace:
> [    3.860531]  [<ffffffff81037c62>] warn_slowpath_common+0x7e/0x96
> [    3.860640]  [<ffffffff81037c8f>] warn_slowpath_null+0x15/0x17
> [    3.860677]  [<ffffffff8104e12d>] worker_enter_idle+0x168/0x19f
> [    3.860677]  [<ffffffff81050d3f>] worker_thread+0x1ed/0x206
> [    3.860677]  [<ffffffff81050b52>] ? manage_workers+0xc0/0xc0
> [    3.860677]  [<ffffffff8105472e>] kthread+0x7f/0x87
> [    3.860677]  [<ffffffff8156bb94>] kernel_thread_helper+0x4/0x10
> [    3.860677]  [<ffffffff81564d84>] ? retint_restore_args+0xe/0xe
> [    3.860677]  [<ffffffff810546af>] ? __init_kthread_worker+0x55/0x55
> [    3.860677]  [<ffffffff8156bb90>] ? gs_change+0xb/0xb
> [    3.860677] ---[ end trace 64d29d8be7ad450b ]---
> 
> and wham it was dead hard at that point,no further output.  Next boot, it hit again,
> and lived a while longer:

> [    3.993411] ------------[ cut here ]------------
> [    3.993531] WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0x168/0x19f()
> [    3.993658] Hardware name: Latitude E6500
> [    3.993764] Modules linked in:
> [    3.993951] Pid: 482, comm: kworker/1:1 Not tainted 2.6.39-rc3-mmotm0414 #1
> [    3.994065] Call Trace:
> [    3.994173]  [<ffffffff81037c62>] warn_slowpath_common+0x7e/0x96
> [    3.994282]  [<ffffffff81037c8f>] warn_slowpath_null+0x15/0x17
> [    3.994381]  [<ffffffff8104e12d>] worker_enter_idle+0x168/0x19f
> [    3.994381]  [<ffffffff81050d3f>] worker_thread+0x1ed/0x206
> [    3.994381]  [<ffffffff81050b52>] ? manage_workers+0xc0/0xc0
> [    3.994381]  [<ffffffff8105472e>] kthread+0x7f/0x87
> [    3.994381]  [<ffffffff8156bb94>] kernel_thread_helper+0x4/0x10
> [    3.994381]  [<ffffffff81564d84>] ? retint_restore_args+0xe/0xe
> [    3.994381]  [<ffffffff810546af>] ? __init_kthread_worker+0x55/0x55
> [    3.994381]  [<ffffffff8156bb90>] ? gs_change+0xb/0xb
> [    3.994381] ---[ end trace 604fcd3646d16bcd ]---

> but it then didn't accept keyboard input from the USB keyboard and acted pretty dead.
> 
> Any ideas, or am I looking at a weekend of bisecting? ;)

Does your kernel contain c2f7115e2e52a6c187b8c1f54f0e4970bb677be0 ? If
not, mmotm is based on an old -next and should upgrade ;-)



