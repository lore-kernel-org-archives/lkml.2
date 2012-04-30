Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2D3AXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:23:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:41102 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab2D3AXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:23:23 -0400
Message-ID: <1335745382.20866.18.camel@pasglop>
Subject: Re: [PATCH] tty/serial/pmac_zilog: Fix "nobody cared" IRQ message
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Apr 2012 10:23:02 +1000
In-Reply-To: <4F9C830D.8040906@lwfinger.net>
References: <4F9C830D.8040906@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 18:53 -0500, Larry Finger wrote:

> 
> Index: wireless-testing/drivers/tty/serial/pmac_zilog.c
> ===================================================================
> --- wireless-testing.orig/drivers/tty/serial/pmac_zilog.c	2012-04-28 
> 15:51:38.843723074 -0500
> +++ wireless-testing/drivers/tty/serial/pmac_zilog.c	2012-04-28 
> 18:34:34.053900600 -0500

Patch seems to be wrapped... I'll apply manually this time around but
check your mailer settings :-)

Cheers,
Ben.

> @@ -469,7 +469,7 @@
>   	tty = NULL;
>   	if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
>   		if (!ZS_IS_OPEN(uap_a)) {
> -			pmz_debug("ChanA interrupt while open !\n");
> +			pmz_debug("ChanA interrupt while not open !\n");
>   			goto skip_a;
>   		}
>   		write_zsreg(uap_a, R0, RES_H_IUS);
> @@ -493,8 +493,8 @@
>   	spin_lock(&uap_b->port.lock);
>   	tty = NULL;
>   	if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
> -		if (!ZS_IS_OPEN(uap_a)) {
> -			pmz_debug("ChanB interrupt while open !\n");
> +		if (!ZS_IS_OPEN(uap_b)) {
> +			pmz_debug("ChanB interrupt while not open !\n");
>   			goto skip_b;
>   		}
>   		write_zsreg(uap_b, R0, RES_H_IUS);


