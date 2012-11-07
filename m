Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2KGJ5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:57:07 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37990 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2KGJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:57:03 -0500
Message-ID: <509A306B.10409@gmail.com>
Date: Wed, 07 Nov 2012 10:56:59 +0100
From: "=?ISO-8859-1?Q?Andreas_Bie=DFmann?=" <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux@arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
In-Reply-To: <1350396562-32579-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.10.2012 16:09, Felipe Balbi wrote:
> This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> (serial: omap: fix software flow control).
> 
> As Russell has pointed out, that commit isn't fixing
> Software Flow Control at all, and it actually makes
> it even more broken.
> 
> It was agreed to revert this commit and use Russell's
> latest UART patches instead.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

since 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6 made it into stable (at
least 3.4) I think it would be good decision to also apply this revert
to stable until a working solution exists.

Best regards

Andreas Bießmann

> ---
> 
> Hi Greg,
> 
> you might prefer to do the revert yourself, in that case just
> revert commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6.
> 
> thanks
> 
>  arch/arm/plat-omap/include/plat/omap-serial.h |  4 ++--
>  drivers/tty/serial/omap-serial.c              | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
> index f4a4cd0..1957a85 100644
> --- a/arch/arm/plat-omap/include/plat/omap-serial.h
> +++ b/arch/arm/plat-omap/include/plat/omap-serial.h
> @@ -40,10 +40,10 @@
>  #define OMAP_UART_WER_MOD_WKUP	0X7F
>  
>  /* Enable XON/XOFF flow control on output */
> -#define OMAP_UART_SW_TX		0x8
> +#define OMAP_UART_SW_TX		0x04
>  
>  /* Enable XON/XOFF flow control on input */
> -#define OMAP_UART_SW_RX		0x2
> +#define OMAP_UART_SW_RX		0x04
>  
>  #define OMAP_UART_SYSC_RESET	0X07
>  #define OMAP_UART_TCR_TRIG	0X0F
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 6ede6fd..6d3d26a 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -671,19 +671,19 @@ serial_omap_configure_xonxoff
>  
>  	/*
>  	 * IXON Flag:
> -	 * Flow control for OMAP.TX
> -	 * OMAP.RX should listen for XON/XOFF
> +	 * Enable XON/XOFF flow control on output.
> +	 * Transmit XON1, XOFF1
>  	 */
>  	if (termios->c_iflag & IXON)
> -		up->efr |= OMAP_UART_SW_RX;
> +		up->efr |= OMAP_UART_SW_TX;
>  
>  	/*
>  	 * IXOFF Flag:
> -	 * Flow control for OMAP.RX
> -	 * OMAP.TX should send XON/XOFF
> +	 * Enable XON/XOFF flow control on input.
> +	 * Receiver compares XON1, XOFF1.
>  	 */
>  	if (termios->c_iflag & IXOFF)
> -		up->efr |= OMAP_UART_SW_TX;
> +		up->efr |= OMAP_UART_SW_RX;
>  
>  	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
>  	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
> 

