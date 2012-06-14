Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2FNLXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:23:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56135 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2FNLXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:23:34 -0400
Date: Thu, 14 Jun 2012 12:23:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        w.sang@pengutronix.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 15/17] i2c: omap: always return IRQ_HANDLED
Message-ID: <20120614112323.GD31187@n2100.arm.linux.org.uk>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-16-git-send-email-balbi@ti.com> <CAMQu2gzbK+ObetarwRiEz9A7=awEffAhrMMAqSMfiv4H6BZAuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMQu2gzbK+ObetarwRiEz9A7=awEffAhrMMAqSMfiv4H6BZAuw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 04:48:56PM +0530, Shilimkar, Santosh wrote:
> On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> > otherwise we could get our IRQ line disabled due
> > to many spurious IRQs.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/i2c/busses/i2c-omap.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> > index fc5b8bc..5b78a73 100644
> > --- a/drivers/i2c/busses/i2c-omap.c
> > +++ b/drivers/i2c/busses/i2c-omap.c
> > @@ -1015,7 +1015,7 @@ omap_i2c_isr(int this_irq, void *dev_id)
> >                }
> >        } while (stat);
> >
> > -       return count ? IRQ_HANDLED : IRQ_NONE;
> > +       return IRQ_HANDLED;
> 
> no sure if this is correct. if you have IRQ flood and instead of _actually_
> handling it, if you return handled, you still have interrupt pending, right?

The point of returning IRQ_NONE is to indicate to the interrupt layer that
the interrupt you received was not processed by any interrupt handler, and
therefore to provide a way of preventing the system being brought to a halt
though a stuck interrupt line.

So, if you do process an interrupt, you should always return IRQ_HANDLED
even if you couldn't complete its processing (eg, because you've serviced
it 100 times.)
