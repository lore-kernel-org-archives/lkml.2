Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2F0CYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:24:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38797 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2F0CYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:24:06 -0400
X-Sasl-enc: JZh0ZTEIP6k6bhVTJxI3Rx/0Z2Vd8DfvTjymd0y7wG/e 1340763846
Date: Tue, 26 Jun 2012 19:24:04 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 05/12] kobil_sct: Fix some bogus tty handling
Message-ID: <20120627022404.GA3314@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
 <20120622154251.1405.12270.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120622154251.1405.12270.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:43:22PM +0100, Alan Cox wrote:
> Stuff noticed while doing the termios conversion.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/usb/serial/kobil_sct.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
> index fafeabb..0852472 100644
> --- a/drivers/usb/serial/kobil_sct.c
> +++ b/drivers/usb/serial/kobil_sct.c
> @@ -192,8 +192,8 @@ static void kobil_init_termios(struct tty_struct *tty)
>  {
>  	/* Default to echo off and other sane device settings */
>  	tty->termios->c_lflag = 0;
> -	tty->termios->c_lflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
> -	tty->termios->c_iflag = IGNBRK | IGNPAR | IXOFF;
> +	tty->termios->c_iflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
> +	tty->termios->c_iflag |= IGNBRK | IGNPAR | IXOFF;
>  	/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
>  	tty->termios->c_oflag &= ~ONLCR;
>  }
> @@ -588,7 +588,7 @@ static void kobil_set_termios(struct tty_struct *tty,
>  	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
>  			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
>  		/* This device doesn't support ioctl calls */
> -		*tty->termios = *old;
> +		tty_termios_copy_hw(tty->termios, old_termios);
>  		return;
>  	}
>  

This patch also breaks the build:

drivers/usb/serial/kobil_sct.c: In function ‘kobil_set_termios’:
drivers/usb/serial/kobil_sct.c:591:37: error: ‘old_termios’ undeclared (first use in this function)
drivers/usb/serial/kobil_sct.c:591:37: note: each undeclared identifier is reported only once for each function it appears in


