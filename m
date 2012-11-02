Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2KBKjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:39:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49411 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2KBKji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:39:38 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <CA+Bv8Xb4eAQ2po-nwCT6ZXNdaU7cwshVaGC795e3GYZ+B7L-jQ@mail.gmail.com>
Date: Fri, 2 Nov 2012 11:39:41 +0100
Cc: balbi@ti.com, Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <041C30E9-0CD2-4CF4-823A-E27B7BFF1BE1@dominion.thruhere.net>
References: <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com> <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com> <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com> <20121102085718.GF17063@arwen.pp.htv.fi> <CA+Bv8Xb4eAQ2po-nwCT6ZXNdaU7cwshVaGC795e3GYZ+B7L-jQ@mail.gmail.com>
To: Russ Dill <Russ.Dill@ti.com>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 2 nov. 2012, om 10:42 heeft Russ Dill <Russ.Dill@ti.com> het volgende geschreven:

> On Fri, Nov 2, 2012 at 1:57 AM, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>> 
>> On Thu, Nov 01, 2012 at 04:49:23PM -0700, Russ Dill wrote:
>>> On Thu, Nov 1, 2012 at 3:05 PM, Felipe Balbi <balbi@ti.com> wrote:
>>>> HI,
>>>> 
>>>> On Thu, Nov 01, 2012 at 03:59:50PM +0200, Pantelis Antoniou wrote:
>>>>> Hi Alan,
>>>>> 
>>>>> On Nov 1, 2012, at 3:51 PM, Alan Cox wrote:
>>>>> 
>>>>>>> What they want, and what every user wants, is I plug this board in, and
>>>>>>> the driver make sure everything is loaded and ready. No, the end users
>>>>>>> don't want to see any of the implementation details of how the bitfile
>>>>>>> is transported; the driver can handle it.
>>>>>> 
>>>>>> That doesn't necessarily make it a bus merely some kind of hotplug
>>>>>> enumeration of devices. That should all work properly both for devices
>>>>>> and busses with spi and i²c as the final bits needed for it got fixed
>>>>>> some time ago.
>>>>>> 
>>>>>> In an ideal world you don't want to be writing custom drivers for stuff.
>>>>>> If your cape routes an i²c serial device to the existing system i²c
>>>>>> busses then you want to just create an instance of any existing driver on
>>>>>> the existing i²c bus not create a whole new layer of goop.
>>>>>> 
>>>>>> It does need to do the plumbing and resource management for the plumbing
>>>>>> but thats not the same as being a bus.
>>>>>> 
>>>>>> Alan
>>>>> 
>>>>> 
>>>>> Fair enough. But there's no such thing a 'hotplug enumeration
>>>>> construct' in Linux yet, and a bus is the closest thing to it. It does
>>>>> take advantage of the nice way device code matches drivers and devices
>>>>> though.
>>>>> 
>>>>> I'm afraid that having the I2C/SPI drivers doing the detection won't
>>>>> work.  The capes can have arbitrary I2C/SPI devices (and even more
>>>>> weird components).  There is no way to assure for example that the I2C
>>>>> device responding to address 'foo' in cape A is the same I2C device
>>>>> responding to the same address in cape B.
>>>> 
>>>> your ->detect() method should take care of that.
>>> 
>>> There isn't some magical serial number in I²C devices that a
>>> ->detect() method can read and the implementation of I²C is somewhat
>>> flexible. One devices read may be another devices write. A detect
>> 
>> look at what other drivers do. You can read a revision register, you can
>> write a command and see if the device responds as expected, it doesn't
>> matter.
> 
> Since a "revision" register isn't required by the I²C spec, it isn't
> implemented on a huge number of chips. Also, having a few dozen probe
> routines come though and write to random address of every single I²C
> device can a) take a really long time, and b) have quite a few
> unintended side effects.
> 
>>> method that only performs reads could easily toggle a gpio that resets
>>> the board, rewrite and eeprom, or set the printer on fire. If you
>> 
>> how ? It's just a read.
> 
> Because the I²C spec is incredibly flexible. For a lot of devices,
> reading from a register is done by writing the register address, and
> then reading the contents. For devices that don't implement registers
> in that way (such as many eeproms), this is just a write.
> 
>>> browse through various detect functions, yes, some of them key off an
>>> ID, but a lot of them just check various registers to see if certain
>>> bits are zero, or certain bits are one. A lot of I²C devices I've
>>> dealt with have no good way of probing them, especially GPIO chips
>>> (you'll notice none of the I²C GPIO expanders have detect functions)
>> 
>> it doesn't mean it can't be done.
> 
> Really? Please, do tell how you would write a detect function for a
> PCA9534. It has 4 registers, an input port registers, an output port
> register, a polarity inversion register, and a configuration register.
> And don't forget, since we are probing, every detect routine for every
> I²C driver will have to run with every I²C address on every bus,
> possibly with both address formats.

Worse, things like early revisions of the picoDLP projector will erase their firmware if you do a linear scan through all addresses. 

regards,

Koen