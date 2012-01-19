Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2ASLQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:16:23 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:48766 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2ASLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:16:19 -0500
Date: Thu, 19 Jan 2012 16:45:58 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: clear previous interrupts before
 request_irq
Message-ID: <20120119111558.GB6115@bnru02.bnr.st.com>
References: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20120118100410.GB889@bnru02.bnr.st.com>
 <20120118114100.064e2c8f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120118114100.064e2c8f@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:41:00 +0100, Alan Cox wrote:
> >  	/*
> > +	 * Clear previous interrupts before installing interrupt handler
> > +	 */
> > +	spin_lock_irq(&uap->port.lock);
> > +	uap->im = 0;
> > +	writew(uap->im, uap->port.membase + UART011_IMSC);
> > +	writew(0xffff, uap->port.membase + UART011_ICR);
> > +	spin_unlock_irq(&uap->port.lock);
> 
> I'm confused why you use spin_lock_irq before you've enabled the IRQ in
> the first place but looks fine.
> 
> Alan
Yes, spin_lock_irq for the port is not required as request_irq is not yet
called for the port.

Thanks and Regards,
Shreshtha
