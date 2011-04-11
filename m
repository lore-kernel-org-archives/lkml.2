Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1DKOtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:49:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753086Ab1DKOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:49:08 -0400
Date: Mon, 11 Apr 2011 06:39:59 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110411133958.GB24973@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC245@KCINPUNHJCMS01.kpit.com>
 <20110406135954.GA2810@opensource.wolfsonmicro.com>
 <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B55613A@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B55613A@KCINPUNHJCMS01.kpit.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 05:01:12PM +0530, Ashish Jangam wrote:

> > > +static inline int da9052_request_irq(struct da9052 *da9052, int irq,
> > > +                                      irq_handler_t handler, const char
> > *name,
> > > +                                      void *data)
> > > + {
> > > +       int ret;
> > > +
> > > +       if (!da9052->irq_base)
> > > +               return -EINVAL;
> > > +
> > > +       ret = request_threaded_irq(da9052->irq_base + irq, NULL, handler,
> > > +                                     IRQF_TRIGGER_LOW | IRQF_ONESHOT, name,
> > > +                                     data);

> > Since you're implementing directly with genirq you don't need this
> > stuff, some drivers have it as they were written before genirq could
> > support devices on sleepy buses.

> DA9052 PMIC is event based so mfd device like touch, onkey, rtc etc gets register to their associated event by this function. In absence of the request_threaded_irq() call there will no mechanism for the said devices to receive their event. Hence we intend to keep this API call.

> In case our explanation is not inline with your review then kindly elaborate.

You're missing the point - the purpose of the code you're copying here
is to transition from an old, non-genirq interface for getting
interrupts to genirq.  Now genirq can be used directly there's no need
to have a custom API in the driver.
