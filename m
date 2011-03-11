Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1CKW0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:26:21 -0500
Received: from kroah.org ([198.145.64.141]:33501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1CKW0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:26:19 -0500
Date: Fri, 11 Mar 2011 14:25:29 -0800
From: Greg KH <greg@kroah.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_uart: reference clock on CM-iTC
Message-ID: <20110311222529.GA14675@kroah.com>
References: <4D74A600.7070302@compulab.co.il>
 <20110307200733.GA18849@kroah.com>
 <4D761F7F.2030908@compulab.co.il>
 <20110309234238.GA4071@kroah.com>
 <4D78CE98.4040500@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D78CE98.4040500@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 03:14:00PM +0200, Denis Turischev wrote:
> Default clock source for UARTs on Topcliff is external UART_CLK.
> On CM-iTC USB_48MHz is used instead. After VCO2PLL and DIV
> manipulations UARTs will receive 192 MHz.
> Clock manipulations on Topcliff are controlled in pch_phub.c
> 
> v2: redone against the linux-next tree
> v3: redone against linux/kernel/git/next/linux-next.git snapshot
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
> diff -Nru linux-next-20110310.orig/drivers/misc/pch_phub.c linux-next-20110310/drivers/misc/pch_phub.c
> --- linux-next-20110310.orig/drivers/misc/pch_phub.c	2011-03-10 08:31:30.000000000 +0200
> +++ linux-next-20110310/drivers/misc/pch_phub.c	2011-03-10 14:42:05.110978473 +0200
> @@ -618,6 +626,14 @@
>  					       CLKCFG_CAN_50MHZ,
>  					       CLKCFG_CANCLK_MASK);
> 
> +		/* quirk for CM-iTC board */
> +		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
> +			pch_phub_read_modify_write_reg(chip,
> +						(unsigned int)CLKCFG_REG_OFFSET,
> +						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
> +						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
> +						CLKCFG_UART_MASK);
> +

This is the chunk that is causing problems.  I guess someone else
modified this file in the linux-next tree, and I can't apply it in mine.
Any ideas who did this change?  Can you look at the linux-next tree and
see what caused this merge issue?

thanks,

greg k-h
