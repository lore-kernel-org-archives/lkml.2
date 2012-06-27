Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2F0CWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:22:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40713 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab2F0CWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:22:34 -0400
X-Sasl-enc: inALeehr/vIAOGo5yAf2x1fNxeYx0wFH1zCr9KHU7NyI 1340763753
Date: Tue, 26 Jun 2012 19:22:32 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/12] f81232: correct stubbed termios handler
Message-ID: <20120627022232.GA32709@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:36:42PM +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/usb/serial/f81232.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index 499b15f..acd3267 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
> @@ -177,6 +177,7 @@ static void f81232_set_termios(struct tty_struct *tty,
>  		return;
>  
>  	/* Do the real work here... */
> +	tty_termios_copy_hw(&tty->termios, old_termios);
>  }

This patch breaks the build:

drivers/usb/serial/f81232.c: In function ‘f81232_set_termios’:
drivers/usb/serial/f81232.c:180:2: warning: passing argument 1 of ‘tty_termios_copy_hw’ from incompatible pointer type [enabled by default]
include/linux/tty.h:454:13: note: expected ‘struct ktermios *’ but argument is of type ‘struct ktermios **’

I know the driver isn't complete, but it should at least build :)

thanks,

greg k-h
