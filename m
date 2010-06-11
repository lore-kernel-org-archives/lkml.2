Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab0FKKIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:08:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50417 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab0FKKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:08:08 -0400
Message-ID: <19474.2817.333749.485028@ipc1.ka-ro>
Date: Fri, 11 Jun 2010 12:08:01 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
In-Reply-To: <20100611095839.GC10894@pengutronix.de>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	<201006111557.12249.jeremy.kerr@canonical.com>
	<19473.61547.684572.647641@ipc1.ka-ro>
	<201006111718.47426.jeremy.kerr@canonical.com>
	<19474.172.742782.972629@ipc1.ka-ro>
	<20100611095839.GC10894@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > > makes it impossible to call those functions in interrupt context.
> IMHO if a device generates an irq its clock should already be on.  This
> way you don't need to enable or disable a clock in irq context.
>  
You may want to disable a clock in the IRQ handler. The VPU driver in
the Freescale BSP for i.MX51 does exactly this.
Anyway I don't see any reason for using a mutex here instead of
spin_lock_irq_save() as all other implementations do.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
