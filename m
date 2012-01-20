Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2ATPnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:43:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53474 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2ATPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:43:44 -0500
Message-ID: <4F198BAB.3010706@gmail.com>
Date: Fri, 20 Jan 2012 16:43:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120106 Thunderbird/10.0
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] serial: trivial checkpatch fixes in drivers/tty/serial/8250.c
References: <1327001868-29941-1-git-send-email-sjg@chromium.org> <1327019067-19115-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1327019067-19115-1-git-send-email-sjg@chromium.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 01:24 AM, Simon Glass wrote:
> @@ -2006,8 +2010,8 @@ static int serial8250_startup(struct uart_port *port)
>  	 */
>  	if (!(up->port.flags & UPF_BUGGY_UART) &&
>  	    (serial_inp(up, UART_LSR) == 0xff)) {
> -		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
> -				   serial_index(&up->port));
> +		pr_info_ratelimited(

FWIW I hate these macros. Beginners ask what the heck stands "pr" for?

> @@ -3053,8 +3063,8 @@ static int __devinit serial8250_probe(struct platform_device *dev)
>  		port.irqflags		|= irqflag;
>  		ret = serial8250_register_port(&port);
>  		if (ret < 0) {
> -			dev_err(&dev->dev, "unable to register port at index %d "
> -				"(IO%lx MEM%llx IRQ%d): %d\n", i,
> +			dev_err(&dev->dev, "unable to register port at "
> +				"index %d (IO%lx MEM%llx IRQ%d): %d\n", i,

Nack to this. It makes grepping harder.

thanks,
-- 
js
