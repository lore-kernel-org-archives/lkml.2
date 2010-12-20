Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0LTHYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:24:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753668Ab0LTHYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:24:11 -0500
X-Authenticated: #54578410
X-Provags-ID: V01U2FsdGVkX1+3bBoiDMS36GXZqb5+Of8baC61+/xU08cNiAdKlx
	XanZvDEBOv9/AX
Message-ID: <4D0F0497.7090306@gmx.de>
Date: Mon, 20 Dec 2010 08:24:07 +0100
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-i2c@fluff.org>, Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
References: <20101216150638.7d3850b5@endymion.delvare>	<20101216160046.GE20097@trinity.fluff.org>	<20101216175337.2b1ae6ee@endymion.delvare>	<4D0B5312.5080107@gmx.de> <20101218000924.546ad703@endymion.delvare>
In-Reply-To: <20101218000924.546ad703@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare said the following:
> Hi Michael,
> 
> On Fri, 17 Dec 2010 13:09:54 +0100, Michael Lawnick wrote:
>> Sorry to disturb, but
>> <MANTRA>
>> 	Disabling interrupts may be done only for a few instructions.</MANTRA>
>> 
>> Even 1 us is an eternity on modern systems.
> 
> Don't be sorry, this is exactly the kind of input I was asking for. I'm
> a little surprised, I thought disabling interrupts for a couple
> microseconds was happening all the time, but I'll trust your
> experience. 

I can't tell whether this is happening all the time, but I can imagine
and I highly discourage this. This is IMHO one of the lessons many LINUX
developers have still to learn. Maybe it's a history reason.

> Given your point and Ben's, it seems clear that my patch is
> not acceptable as is, and at the very least I should make the spinlock
> usage optional.

At last you might not come around your solution, but a H/W-S/W
combination driving you in such a direction should be considered broken.
Using it in professional environment needs heavy discussions about pros
and cons, best would be to beat the H/W designers to provide a real
controller.
Of course it may be used in a case, where you simply need a (temporary)
hack to get something working.

-- 
KR
Michael
