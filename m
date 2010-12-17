Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0LQMKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:10:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41585 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752907Ab0LQMJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:09:58 -0500
X-Authenticated: #54578410
X-Provags-ID: V01U2FsdGVkX1/MjaBpA5XMAeIgta4BPFe1Diq04UosHdPnOPLoY4
	9Ye1X+kXZPKAEP
Message-ID: <4D0B5312.5080107@gmx.de>
Date: Fri, 17 Dec 2010 13:09:54 +0100
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-i2c@fluff.org>, Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
References: <20101216150638.7d3850b5@endymion.delvare>	<20101216160046.GE20097@trinity.fluff.org> <20101216175337.2b1ae6ee@endymion.delvare>
In-Reply-To: <20101216175337.2b1ae6ee@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare said the following:
> Hi Ben,
> 
> On Thu, 16 Dec 2010 16:00:46 +0000, Ben Dooks wrote:
>> On Thu, Dec 16, 2010 at 03:06:38PM +0100, Jean Delvare wrote:
>> > Add a spinlock to every user of i2c-algo-bit, which is taken before
>> > raising SCL and released after lowering SCL. We don't really need
>> > the exclusion functionality, but we have to disable local interrupts.
>> > This is needed to comply with SMBus requirements that SCL shouldn't
>> > be high for longer than 50 us.
>> > 
>> > SMBus slaves can consider SCL being high for 50 us as a timeout
>> > condition. This has been observed to happen reproducibly with the
>> > Melexis MLX90614.
>> > 
>> > The drawback of this approach is that spin_lock_irqsave() and
>> > spin_unlock_irqrestore() will be called once for each bit going on the
>> > I2C bus in either direction. This can mean up to 100 kHz for standard
>> > I2C and SMBus and up to 250 kHz for fast I2C. The good thing is that
>> > this limits the latency to reasonable values (2us at 250 kHz, 5 us at
>> > 100 kHz and 50 us at 10 kHz).
>> 
>> Hmm, this is going to be a drain on interrupt latency... disabling
>> interrupts in a system for that long could cause other things to
>> jitter.
> 
> So you consider that even disabling interrupts for 5 us is too long? Or
> are you only worried by the 50 us case?

Sorry to disturb, but
<MANTRA>
	Disabling interrupts may be done only for a few instructions.</MANTRA>

Even 1 us is an eternity on modern systems.

JM2C

-- 
KR
Michael
