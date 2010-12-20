Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0LTNFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:05:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:41709 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0LTNFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:05:18 -0500
Date: Mon, 20 Dec 2010 14:04:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael Lawnick <ml.lawnick@gmx.de>
Cc: Ben Dooks <ben-i2c@fluff.org>, Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
Message-ID: <20101220140459.506d51b7@endymion.delvare>
In-Reply-To: <4D0F0497.7090306@gmx.de>
References: <20101216150638.7d3850b5@endymion.delvare>
	<20101216160046.GE20097@trinity.fluff.org>
	<20101216175337.2b1ae6ee@endymion.delvare>
	<4D0B5312.5080107@gmx.de>
	<20101218000924.546ad703@endymion.delvare>
	<4D0F0497.7090306@gmx.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Mon, 20 Dec 2010 08:24:07 +0100, Michael Lawnick wrote:
> Jean Delvare said the following:
> > Hi Michael,
> > 
> > On Fri, 17 Dec 2010 13:09:54 +0100, Michael Lawnick wrote:
> >> Sorry to disturb, but
> >> <MANTRA>
> >> 	Disabling interrupts may be done only for a few instructions.</MANTRA>
> >> 
> >> Even 1 us is an eternity on modern systems.
> > 
> > Don't be sorry, this is exactly the kind of input I was asking for. I'm
> > a little surprised, I thought disabling interrupts for a couple
> > microseconds was happening all the time, but I'll trust your
> > experience. 
> 
> I can't tell whether this is happening all the time, but I can imagine
> and I highly discourage this. This is IMHO one of the lessons many LINUX
> developers have still to learn. Maybe it's a history reason.
> 
> > Given your point and Ben's, it seems clear that my patch is
> > not acceptable as is, and at the very least I should make the spinlock
> > usage optional.
> 
> At last you might not come around your solution, but a H/W-S/W
> combination driving you in such a direction should be considered broken.

I don't disagree, but the fact is that i2c-algo-bit is frequently used.
It's used by all framebuffer and KMS drivers which want to read the
EDID data from the screen. It's also used by a large number of V4L and
DVB drivers.

Note that, in the cases above, the current i2c-algo-bit implementation
should be OK. These are cards with I2C devices mostly, not SMBus
devices, so they are much more tolerant to slow SCL.

> Using it in professional environment needs heavy discussions about pros
> and cons, best would be to beat the H/W designers to provide a real
> controller.

For future designs, certainly. But we also have to deal with the
existing hardware.

> Of course it may be used in a case, where you simply need a (temporary)
> hack to get something working.

The problem is that "temporary" tends to stay, either because there is
no other way, or because the hardware implementation is unreliable or
limited, or because we don't have the specifications of the hardware
implementation. So I don't see i2c-algo-bit going away anytime soon.

-- 
Jean Delvare
