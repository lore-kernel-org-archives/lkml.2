Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1CKNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:50:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33244 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753205Ab1CKNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:50:26 -0500
Date: Fri, 11 Mar 2011 13:50:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 1/3] tty: serial: Use hub6_serial_X when
 CONFIG_SERIAL_8250_HUB6 is defined
Message-ID: <20110311135024.400582fd@lxorguk.ukuu.org.uk>
In-Reply-To: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these are not needed

> +#if CONFIG_SERIAL_8250_HUB6
>  static unsigned int hub6_serial_in(struct uart_port *p, int offset)
>  {
>  	offset = map_8250_in_reg(p, offset) << p->regshift;
> @@ -400,6 +401,7 @@ static void hub6_serial_out(struct uart_port *p, int offset, int value)
>  	outb(p->hub6 - 1 + offset, p->iobase);
>  	outb(value, p->iobase + 1);
>  }
> +#endif

This one is needed 
>  
>  static unsigned int mem_serial_in(struct uart_port *p, int offset)
>  {
> @@ -508,10 +510,12 @@ static void set_io_from_upio(struct uart_port *p)
>  	struct uart_8250_port *up =
>  		container_of(p, struct uart_8250_port, port);
>  	switch (p->iotype) {
> +#if CONFIG_SERIAL_8250_HUB6
>  	case UPIO_HUB6:
>  		p->serial_in = hub6_serial_in;
>  		p->serial_out = hub6_serial_out;
>  		break;
> +#endif

And this - but not the rest.

It is also such a miniscule amount of code it seems like it does not
justify the complexity of being configurable this way.

