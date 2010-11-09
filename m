Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0KIDY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:24:57 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53348 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0KIDY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:24:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] vmstat: fix offset calculation on void*
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "mrubin@google.com" <mrubin@google.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101103175648.GA6398@localhost>
References: <20101103175648.GA6398@localhost>
Message-Id: <20101109122527.BC57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 12:24:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix regression introduced by commit 79da826aee6.
> 
> 	BUG: unable to handle kernel paging request at 07c06d16
> 	IP: [<c050c336>] strnlen+0x6/0x20
> 
> 	Call Trace:
> 	 [<c050a249>] ? string+0x39/0xe0
> 	 [<c042be6b>] ? __wake_up_common+0x4b/0x80
> 	 [<c050afcc>] ? vsnprintf+0x1ec/0x380
> 	 [<c04b380e>] ? seq_printf+0x2e/0x60
> 	 [<c04829a6>] ? vmstat_show+0x26/0x30
> 	 [<c04b3bb6>] ? seq_read+0xa6/0x380
> 	 [<c04b3b10>] ? seq_read+0x0/0x380
> 	 [<c04d5d2f>] ? proc_reg_read+0x5f/0x90
> 	 [<c049c4a1>] ? vfs_read+0xa1/0x140
> 	 [<c04d5cd0>] ? proc_reg_read+0x0/0x90
> 	 [<c049c981>] ? sys_read+0x41/0x70
> 	 [<c0402bd0>] ? sysenter_do_call+0x12/0x26
> 
> 
> CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> CC: Michael Rubin <mrubin@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> 
> Hopefully Tetsuo can test it soon, thanks!
> 
>  mm/vmstat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/mm/vmstat.c	2010-11-04 01:49:12.000000000 +0800
> +++ linux-2.6/mm/vmstat.c	2010-11-04 01:49:23.000000000 +0800
> @@ -949,7 +949,7 @@ static void *vmstat_start(struct seq_fil
>  	v[PGPGIN] /= 2;		/* sectors -> kbytes */
>  	v[PGPGOUT] /= 2;
>  #endif
> -	return m->private + *pos;
> +	return (unsigned long *)m->private + *pos;
>  }
>  
>  static void *vmstat_next(struct seq_file *m, void *arg, loff_t *pos)

Good catch!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





