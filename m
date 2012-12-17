Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2LQIRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:17:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2LQIRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:17:11 -0500
Date: Mon, 17 Dec 2012 10:17:07 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: BUG: MAX_LOCK_DEPTH too low!
Message-ID: <20121217081707.GD11016@redhat.com>
References: <20121217081447.GB24173@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217081447.GB24173@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying Andrea.

On Mon, Dec 17, 2012 at 10:14:47AM +0200, Kirill A. Shutemov wrote:
> Hi,
> 
> I've got this BUG on up-to-date Linus tree (aed606e):
> 
> [ 1145.439071] BUG: MAX_LOCK_DEPTH too low!
> [ 1145.439077] turning off the locking correctness validator.
> [ 1145.439081] Pid: 4619, comm: kvm Not tainted 3.7.0-08682-gaed606e-dirty #166
> [ 1145.439084] Call Trace:
> [ 1145.439094]  [<ffffffff810e6094>] __lock_acquire.isra.24+0xc54/0xe10
> [ 1145.439099]  [<ffffffff810e6873>] lock_acquire+0x93/0x140
> [ 1145.439106]  [<ffffffff8117bfa8>] ? mm_take_all_locks+0x148/0x1b0
> [ 1145.439111]  [<ffffffff8173d239>] down_write+0x49/0x90
> [ 1145.439115]  [<ffffffff8117bfa8>] ? mm_take_all_locks+0x148/0x1b0
> [ 1145.439119]  [<ffffffff8117bfa8>] mm_take_all_locks+0x148/0x1b0
> [ 1145.439124]  [<ffffffff81192253>] ? do_mmu_notifier_register+0x153/0x180
> [ 1145.439128]  [<ffffffff8119217f>] do_mmu_notifier_register+0x7f/0x180
> [ 1145.439132]  [<ffffffff811922b3>] mmu_notifier_register+0x13/0x20
> [ 1145.439138]  [<ffffffff81006036>] kvm_dev_ioctl+0x3e6/0x520
> [ 1145.439142]  [<ffffffff810e40e8>] ? debug_check_no_locks_freed+0xd8/0x170
> [ 1145.439148]  [<ffffffff811be6c7>] do_vfs_ioctl+0x97/0x540
> [ 1145.439152]  [<ffffffff811bec01>] sys_ioctl+0x91/0xb0
> [ 1145.439158]  [<ffffffff8132464e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1145.439163]  [<ffffffff817478c6>] system_call_fastpath+0x1a/0x1f
> 
> -- 
>  Kirill A. Shutemov

--
			Gleb.
