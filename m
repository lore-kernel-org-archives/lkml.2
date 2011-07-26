Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1GZQYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:24:42 -0400
Received: from lunge.queued.net ([173.255.254.236]:37562 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1GZQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:24:36 -0400
Date: Tue, 26 Jul 2011 09:24:27 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        pgf@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, olpc: Wait for last byte of EC command to be
 accepted
Message-ID: <20110726092427.3bce52a2@debxo>
In-Reply-To: <20110726154226.93A9F9D401C@zog.reactivated.net>
References: <20110726154226.93A9F9D401C@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andres Salomon <dilinger@queued.net>

After some squinting.. This patch looks correct.  This is a
long-standing issue, we should probably add a Cc: stable@kernel.org so
it gets picked up for stable kernels.

On Tue, 26 Jul 2011
16:42:26 +0100 (BST) Daniel Drake <dsd@laptop.org> wrote:

> From: Paul Fox <pgf@laptop.org>
> 
> When executing EC commands, only waiting when there are still more
> bytes to write is usually fine. However, if the system suspends very
> quickly after a call to olpc_ec_cmd(), the last data byte may not yet
> be transferred to the EC, and the command will not complete.
> 
> This solves a bug where the SCI wakeup mask was not correctly written
> when going into suspend.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/platform/olpc/olpc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/olpc/olpc.c
> b/arch/x86/platform/olpc/olpc.c index 8b9940e..7cce722 100644
> --- a/arch/x86/platform/olpc/olpc.c
> +++ b/arch/x86/platform/olpc/olpc.c
> @@ -161,13 +161,13 @@ restart:
>  	if (inbuf && inlen) {
>  		/* write data to EC */
>  		for (i = 0; i < inlen; i++) {
> +			pr_devel("olpc-ec:  sending cmd arg 0x%x\n",
> inbuf[i]);
> +			outb(inbuf[i], 0x68);
>  			if (wait_on_ibf(0x6c, 0)) {
>  				printk(KERN_ERR "olpc-ec:  timeout
> waiting for" " EC accept data!\n");
>  				goto err;
>  			}
> -			pr_devel("olpc-ec:  sending cmd arg 0x%x\n",
> inbuf[i]);
> -			outb(inbuf[i], 0x68);
>  		}
>  	}
>  	if (outbuf && outlen) {

