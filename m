Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0EIWFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:05:15 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47037 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0EIWEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <1273011539-13994-1-git-send-email-agust@denx.de>
References: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com> 
	<1273011539-13994-1-git-send-email-agust@denx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 10 May 2010 00:04:30 +0200
X-Google-Sender-Auth: 3f208bfce532a988
Message-ID: <i2xfa686aa41005091504ve2b35a09m23cd2dc13a331f86@mail.gmail.com>
Subject: Re: [PATCH] serial: mpc52xx_uart: fix null pointer dereference
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       leonardo.lists@gmail.com, gregkh@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 12:18 AM, Anatolij Gustschin <agust@denx.de> wrote:
> Commit 6acc6833510db8f72b5ef343296d97480555fda9
> introduced NULL pointer dereference and kernel crash
> on ppc32 machines while booting. Fix this bug now.
>
> Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>

Thanks for being so quick to pick up on this Anatolij.  I've been
traveling and not able to respond to stuff.  I see that Greg has
already picked this up (thanks Greg!), but FWIW:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Actually, now that I look, this fix needs to go into Linus' tree right
away (not just linux-next) since the offending patch went in during
the 2.6.34 merge window.

Greg, I can either pick this up and push it out to Linus tomorrow, or
let you do it.  Whichever you prefer.  Let me know so I don't cause
conflicts in your tree.

On another note, this patch isn't actually the right fix, but that's
because this driver is such a horribly bad example of handling private
data that doing the right thing requires some re-architecting.  The
driver should not need any of that extra code in the module_init hook.
 For now this is the best thing to do, but I'll dig into it tomorrow
and see if I can churn out a patch to fix it properly for the 2.6.35
merge window.

Cheers and thanks,
g.

> ---
>  drivers/serial/mpc52xx_uart.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
> index a176ab4..02469c3 100644
> --- a/drivers/serial/mpc52xx_uart.c
> +++ b/drivers/serial/mpc52xx_uart.c
> @@ -1467,7 +1467,7 @@ mpc52xx_uart_init(void)
>        /*
>         * Map the PSC FIFO Controller and init if on MPC512x.
>         */
> -       if (psc_ops->fifoc_init) {
> +       if (psc_ops && psc_ops->fifoc_init) {
>                ret = psc_ops->fifoc_init();
>                if (ret)
>                        return ret;
> --
> 1.7.0.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
