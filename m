Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2HUNQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:16:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55215 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2HUNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:16:15 -0400
Date: Tue, 21 Aug 2012 14:20:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        team-fjord@googlegroups.com
Subject: Re: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20120821142047.777e4bb0@pyramind.ukuu.org.uk>
In-Reply-To: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
References: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -53,7 +53,7 @@ source "drivers/tty/serial/Kconfig"
>  
>  config TTY_PRINTK
>  	bool "TTY driver to output user messages via printk"
> -	depends on EXPERT
> +	depends on EXPERT && TTY


A lot of these could be done better with an if I think - notably the
serial one and perhaps some of the input ones if the tty users were
bunched together.


>  config MOUSE_PS2
>  	tristate "PS/2 mouse"
> +	depends on TTY

It shouldn't. It would be good to understand why this occurs.


> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 5dbb3cb..c1406e3 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -377,7 +377,12 @@ extern void tty_write_flush(struct tty_struct *);
>  
>  extern struct ktermios tty_std_termios;
>  
> +#ifdef CONFIG_TTY
>  extern void console_init(void);
> +#else
> +static inline void console_init(void)
> +{ }
> +#endif

Please can you bunch the whole lot up into one #if defined() / #else /
#endif

rather than lots.


Otherwise this looks very sensible to me.
