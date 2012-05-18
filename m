Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693Ab2ERL1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:27:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854Ab2ERL1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:27:10 -0400
Message-ID: <1337340419.573.32.camel@twins>
Subject: Re: [tip:core/debug] kdump: Execute kmsg_dump(KMSG_DUMP_PANIC)
 after smp_send_stop()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, satoru.moriya@hds.com,
        linux-kernel@vger.kernel.org, seiji.aguchi@hds.com,
        tony.luck@intel.com, dle-develop@lists.sourceforge.net,
        tglx@linutronix.de, dzickus@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 13:26:59 +0200
In-Reply-To: <tip-f80f749132165fb083865e51afd65cf0f05dcd62@git.kernel.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com>
	 <tip-f80f749132165fb083865e51afd65cf0f05dcd62@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 03:49 -0700, tip-bot for Seiji Aguchi wrote:

> kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()
> 
> This patch moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop(),
> to serialize the crash-logging process via smp_send_stop() and to
> thus retrieve a more stable crash image of all CPUs stopped.

I don't want to be a spoil sport or anything, but this patch doesn't
move anything, it just removes..

> ---
>  kernel/panic.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b6215b7..d4f0b61 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -108,8 +108,6 @@ void panic(const char *fmt, ...)
>  	 */
>  	crash_kexec(NULL);
>  
> -	kmsg_dump(KMSG_DUMP_PANIC);
> -
>  	/*
>  	 * Note smp_send_stop is the usual smp shutdown function, which
>  	 * unfortunately means it may not be hardened to work in a panic


