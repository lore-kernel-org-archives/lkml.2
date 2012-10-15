Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2JOWxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:53:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51953 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2JOWxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:53:02 -0400
Date: Mon, 15 Oct 2012 15:52:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "ccross@android.com" <ccross@android.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zhang, Di" <di.zhang@intel.com>, "Ma, Xindong" <xindong.ma@intel.com>,
        "Zuo, Alex" <alex.zuo@intel.com>
Subject: Re: Fix memory leak in binder--version2
Message-ID: <20121015225252.GA14167@kroah.com>
References: <EE928378561BF1449699C96571234A740FE67913@SHSMSX102.ccr.corp.intel.com>
 <EE928378561BF1449699C96571234A740FE67A7D@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE928378561BF1449699C96571234A740FE67A7D@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:20:01AM +0000, Tu, Xiaobing wrote:
> After enabling kmemleak and run monkey, following memleak is reported:
> unreferenced object 0xeed27f80 (size 64):
>   comm "Binder_8", pid 641, jiffies 4294946341 (age 2275.810s)
>   hex dump (first 32 bytes):
>     4f dd 00 00 84 7f d2 ee 84 7f d2 ee 01 00 00 00  O...............
>     00 00 00 00 00 00 00 00 00 aa 4c d7 00 00 00 00  ..........L.....
>   backtrace:
>     [<c184fabc>] kmemleak_alloc+0x3c/0xa0
>     [<c12f391e>] kmem_cache_alloc_trace+0x9e/0x180
>     [<c1668bb5>] binder_thread_write+0xcf5/0x23a0
>     [<c166b091>] binder_ioctl+0x1f1/0x530
>     [<c130dcf6>] do_vfs_ioctl+0x86/0x5e0
>     [<c130e282>] sys_ioctl+0x32/0x60
>     [<c1872e01>] syscall_call+0x7/0xb
>     [<ffffffff>] 0xffffffff
> 
> The work item in async_todo list is not freed when binder released.
> Also the async transaction should also be freed in binder_release_work.
> 
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> Signed-off-by: Di Zhang <di.zhang@intel.com>
> ---
>  drivers/staging/android/binder.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Nice fix, but next time can you at least use scripts/get_maintainer.pl
to figure out who to send this to?  I'll queue it up soon, but it took
akpm to point me at this for me to notice it.

thanks,

greg k-h
