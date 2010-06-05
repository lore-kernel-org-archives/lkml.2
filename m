Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0FEPeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 11:34:06 -0400
Received: from www.tglx.de ([62.245.132.106]:33979 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0FEPeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 11:34:02 -0400
Date: Sat, 5 Jun 2010 17:33:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <maz@misterjones.org>
cc: Esben Haabendal <esbenhaabendal@gmail.com>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
Message-ID: <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Marc Zyngier wrote:

> On Sat, 5 Jun 2010 15:56:01 +0200
> Esben Haabendal <esbenhaabendal@gmail.com> wrote:
> 
> > I have a board with an I2C PCA9535 chip with two PHY interrupt lines
> > hooked up to. The pca953x driver calls set_irq_nested_thread on all
> > irq's on initialization. The PHY driver then calls request_irq, and has
> > no idea that it should actually be using a threaded handler.
> > 
> > With this patch, the PHY driver is able to work in this scenario
> > without changes (and so should any other driver using request_irq).
> 
> You may want to give request_any_context_irq() a try (available since the
> latest merge window). It still requires your driver to be changed, but it
> should then work in both threaded and non-threaded cases.

And it nicely annotates that somebody looked at the driver in
question. That's the rule of least surprise and does not impose checks
on the fast path.

Thanks,

	tglx
