Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0JANYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:24:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41940 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0JANYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dh+n3SdcCfWO3pKWAjwZutbgxcQ6POH2T8mw4Ci/UHXL/+0EamjBPn24iQtB/JHP2Q
         DYQFWeoh8iWf0Y6mTbfYe6ckYbDoCZDQPa14gOXWU0rUYY8wuRjZm5PC60kYErgxF217
         oF8ZVufISDrlNoR/U3zHkzx2Rj0p5MNfGB+Hg=
Date: Fri, 1 Oct 2010 17:24:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] altera_uart: Add support for different address
 strides
Message-ID: <20101001132410.GA31074@oksana.dev.rtsoft.ru>
References: <20100928133537.GD8289@oksana.dev.rtsoft.ru>
 <20100928152929.GD3137@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100928152929.GD3137@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 05:29:29PM +0200, Tobias Klauser wrote:
[...]
> >  struct altera_uart {
> >  	struct uart_port port;
> >  	struct timer_list tmr;
> > +	int bus_shift;
> 
> This member is never used (only bus_shift from struct
> altera_uart_platform_uart). Seems to be a leftover.

Fixed, thanks!

> >  	unsigned int sigs;	/* Local copy of line sigs */
> >  	unsigned short imr;	/* Local IMR mirror */
> >  };
> >  
> > +static u32 altera_uart_readl(struct uart_port *port, int reg)
> > +{
> > +	struct altera_uart_platform_uart *platp = port->private_data;
> > +
> > +	return readl(port->membase + (reg << platp->bus_shift));
> > +}
> > +
> > +static void altera_uart_writel(struct uart_port *port, u32 dat, int reg)
> > +{
> > +	struct altera_uart_platform_uart *platp = port->private_data;
> > +
> > +	writel(dat, port->membase + (reg << platp->bus_shift));
> > +}
> 
> Why not make these inline?

I trust the compiler. If it decides that the code would be
more optimal, it will inline them anyway. ;-)

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
