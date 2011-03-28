Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1C1OUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:20:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab1C1OUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:20:31 -0400
Date: Mon, 28 Mar 2011 07:11:06 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lukasz.Rymanowski@tieto.com, par-gunnar.p.hjalmdahl@stericsson.com,
        devel@driverdev.osuosl.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        pavan_savoy@sify.com, vitalywool@gmail.com, alan@lxorguk.ukuu.org.uk,
        arnd@arndb.de, marcel@holtmann.org, linus.walleij@stericsson.com,
        pghatwork@gmail.com, lee.jones@linaro.org, mathieu.poirier@linaro.org
Subject: Re: [PATCH v2 1/2] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110328141106.GA19350@suse.de>
References: <1301302950-10628-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <alpine.LFD.2.00.1103281110210.31464@localhost6.localdomain6>
 <7D7F2FD3846CF6429ACEBDFB5A2DD86F07E35E5F89@EXMB01.eu.tieto.com>
 <alpine.LFD.2.00.1103281221250.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103281221250.31464@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:21:53PM +0200, Thomas Gleixner wrote:
> On Mon, 28 Mar 2011, Lukasz.Rymanowski@tieto.com wrote:
> 
> > >> +/**
> > >> + * cts_interrupt() - Called to handle CTS interrupt.
> > >> + * @irq:	Interrupt that occurred.
> > >> + * @dev_id:	Device ID where interrupt occurred.
> > >> + *
> > >> + * The cts_interrupt() function is called if interrupt on CTS occurred.
> > >> + * It disables the interrupt and starts a new work thread to handle
> > >> + * the interrupt.
> > >> + */
> > >> +static irqreturn_t cts_interrupt(int irq, void *dev_id) {
> > >> +	struct uart_info *uart_info = dev_get_drvdata(dev_id); #ifdef 
> > >> +CONFIG_PM
> > >> +	disable_irq_wake(irq);
> > >> +#endif
> > >> +	disable_irq_nosync(irq);
> > >> +
> > >> +	/* Create work and leave IRQ context. */
> > >> +	(void)create_work_item(uart_info, handle_cts_irq);
> > >> +
> > >> +	return IRQ_HANDLED;
> > >> +}
> > 
> > >Have you thought about using a threaded interrupt handler? That would make all this work cruft go away.
> > 
> > Good point.
> > To be honest we did think about it but in the time we where we were busy with other issues.
> > Anyway, shall we resend patches now or we can push patch for it once driver gets in the tree ?
> 
> Up to Greg.

Just send patches after it's in the linux-next tree.  Give it a week or
so before that happens due to .39-rc1 issues at the moment and vacation
schedules...

thanks,

greg k-h
