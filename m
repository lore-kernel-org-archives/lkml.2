Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2F0Ca1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:30:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39355 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab2F0Ca0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:30:26 -0400
X-Sasl-enc: BAs4GIGxjg7GiMAOsPDWLh6KHtEj7/kqSGTNBfgd168k 1340764225
Date: Tue, 26 Jun 2012 19:30:24 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 06/12] 8250: use the 8250 register interface not the
 legacy one
Message-ID: <20120627023024.GA13576@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
 <20120622154333.1405.21372.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622154333.1405.21372.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:43:51PM +0100, Alan Cox wrote:
> @@ -69,7 +69,6 @@ struct uart_port;
>  struct uart_8250_port;
>  
>  int serial8250_register_8250_port(struct uart_8250_port *);
> -int serial8250_register_port(struct uart_port *);

There are still in-kernel callers of this function, so I don't think
it's safe to remove just yet, otherwise the build will break:

drivers/char/mwave/mwavedd.c:   return serial8250_register_port(&uart);
drivers/misc/ibmasm/uart.c:     sp->serial_line = serial8250_register_port(&uport);
drivers/net/ethernet/sgi/ioc3-eth.c:    serial8250_register_port(&port);
drivers/tty/serial/of_serial.c:         ret = serial8250_register_port(&port);

I'm stopping here on this series, I've only applied the one that added
the comment, that seems to be the only one that compiled properly :(

Care to redo these please?

thanks,

greg k-h
