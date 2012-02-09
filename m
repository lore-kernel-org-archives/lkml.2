Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2BIIk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:40:29 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51436 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2BIIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:40:27 -0500
Message-ID: <20275.34409.978854.416870@ipc1.ka-ro>
Date: Thu, 9 Feb 2012 09:40:09 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] genirq: Fix race condition in ONESHOT irq handler
In-Reply-To: <alpine.LFD.2.02.1202081123390.2794@ionos>
References: <4F31220A.2050708@metafoo.de>
	<1328621921-17404-1-git-send-email-LW@KARO-electronics.de>
	<alpine.LFD.2.02.1202071719340.2794@ionos>
	<20274.4237.63380.338503@ipc1.ka-ro>
	<alpine.LFD.2.02.1202081123390.2794@ionos>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thomas Gleixner writes:
> On Wed, 8 Feb 2012, Lothar Waßmann wrote:
> > > > The problem arises also with interrupt controllers that latch a level
> > > > triggered IRQ until it is acknowledged (like the i.MX28 does).
> > > > In this case the IRQ status bit will remain asserted after the
> > > > soft-irq finishes and retrigger the interrupt while the interrupt line
> > > > is already deasserted.
> > > 
> > > This does not make sense. We acknowledge interrupts via mask_ack_irq()
> > > right on entry of handle_level_irq(). So either the interrupt
> > > 
> > That's right. But at that point the IRQ line is still asserted and
> > since it is a level IRQ this will not actually clear the interrupt
> > status bit. Normally the IRQ status bit would self-clear when the IRQ
> > line is being deasserted (in this case by removing the finger from the
> > touch panel). But the i.MX28 leaves the IRQ status bit set and it
> > takes another write to the IRQ status register to remove the bogus IRQ
> > status.
> 
> So the question is whether the imx irq chip implementation should
> write to the status register on unmask for level type irqs to avoid
> spurious interrupts being generated in the first place. This is not
> only an optimization for threaded interrupts, afaict this spurious
> effect should happen with non threaded interrupts as well.
> 
> Did my patch work for you ?
> 
Sorry, I couldn't test it earlier. Yes, it works.

Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
