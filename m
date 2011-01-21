Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1AUKNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:13:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1AUKNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cw/3EaatsIac3JmK3HXYQUyTxMT+JnU6H5gEoiPCRb+ckRjvTKo6TvWMx+l70x+f4s
         EsJT6l9lJPJ7vRBLEgabzuNf8n76H2o1oRhkvcXKx+81zaavFJpmLZPjyFFGZXLBhA2w
         R74n8dezo7xTyJByE9vWAPdkRYn6GEl15g7eY=
MIME-Version: 1.0
In-Reply-To: <1295604084-27761-1-git-send-email-weber@corscience.de>
References: <1295604084-27761-1-git-send-email-weber@corscience.de>
From: Govindraj <govindraj.ti@gmail.com>
Date: Fri, 21 Jan 2011 15:42:57 +0530
Message-ID: <AANLkTikSznkcNwkVaPswx=zr8FFGQPVMw_AebF9ymZLE@mail.gmail.com>
Subject: Re: [PATCHv3] OMAP: Enable Magic SysRq on serial console ttyOx
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, manjugk@ti.com, gadiyar@ti.com,
        tony@atomide.com, govindraj@ti.com, gregkh@suse.de,
        andrei.emeltchenko@nokia.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 3:31 PM, Thomas Weber <weber@corscience.de> wrote:
> Magic SysRq key is not working for OMAP on new serial
> console ttyOx because SUPPORT_SYSRQ is not defined
> for omap-serial.
>
> This patch defines SUPPORT_SYSRQ in omap-serial and
> enables handling of Magic SysRq character.
>
> Further there is an issue of losing first break character.
> Removing the reset of the lsr_break_flag fixes this issue.
>
> Signed-off-by: Thomas Weber <weber@corscience.de>


Acked-by: Govindraj.R <govindraj.raja@ti.com>
Tested-by: Manjunath G Kondaiah <manjugk@ti.com>


> ---
>  drivers/serial/omap-serial.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> index 7f2f010..699b344 100644
> --- a/drivers/serial/omap-serial.c
> +++ b/drivers/serial/omap-serial.c
> @@ -20,6 +20,10 @@
>  * this driver as required for the omap-platform.
>  */
>
> +#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> @@ -190,7 +194,6 @@ static inline void receive_chars(struct uart_omap_port *up, int *status)
>                        if (up->port.line == up->port.cons->index) {
>                                /* Recover the break flag from console xmit */
>                                lsr |= up->lsr_break_flag;
> -                               up->lsr_break_flag = 0;
>                        }
>  #endif
>                        if (lsr & UART_LSR_BI)
> --
> 1.7.4.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
