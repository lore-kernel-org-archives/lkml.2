Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2L0RK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:10:58 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57448 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2L0RKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <1356626802.5433.34.camel@anish-Inspiron-N5050>
References: <20121227082724.GA11775@zuhnb712.ap.bm.net>
	<CAKON4OwtPJYRp=FevsX5NLzohX=iLxf2FS0dG4hmdpcGayBy8Q@mail.gmail.com>
	<1356626802.5433.34.camel@anish-Inspiron-N5050>
Date: Thu, 27 Dec 2012 12:10:54 -0500
Message-ID: <CAKON4Ozx6N0v6AQ-60poN+cuCFxPEfW9JQ8OXL==8TxaeUyGmA@mail.gmail.com>
Subject: Re: What does ISA/PCI really mean to ARM architecture?
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Woody Wu <narkewoody@gmail.com>, kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:46 AM, anish kumar
<anish198519851985@gmail.com> wrote:
> On Thu, 2012-12-27 at 11:22 -0500, jonsmirl@gmail.com wrote:
>> On Thu, Dec 27, 2012 at 3:27 AM, Woody Wu <narkewoody@gmail.com> wrote:
>> > Hi, list
>> >
>> > I know this might be a very basic question.  But I really don't clear at
>> > it.
>> >
>> > Can a peripheral chip that claims to be ISA or PCI device be used in a
>> > ARM based embedded system?  For these kind of chips, I only concern
>> > about the planar kind of devices, means they are not on a dedicated
>> > expansion card.
>> >
>> > From hardware point of view, to attach a ISA or PCI planar chip, is
>> > there any requirement need to fulfill on a ARM board?
>>
>> See if your ARM CPU has an interface for SRAM (in addition to DRAM).
>> You can use a SRAM chip select to access ISA type devices. But you may
> Would you mind explaining this in detail?

The old ISA bus is very similar to modern SRAM interfaces.  Address
latch enable + R/W + data strobe. Not DRAM interfaces which are
different.  See if your CPU supports attaching SRAM and then look at
the timing diagrams.  You can probably make it work with some logic
glue.

>> need additional buffers/latches to do this.
>>
>> Another solution is to attach you peripherals using USB. Almost all
> Connect using USB what does this mean?

Find the peripheral function you are looking for in a a chip with USB
device support. Most ARM CPUs have USB host support. Pick chips with
on-chip PHY support.

>> embedded wifi chips are attached this way. The USB connectors aren't
>> required, you can route USB around on your PCB. USB hub chips are
>> $0.35 if you need more ports.  USB Ethernet chips are available.
>>
>> Other options include SPI/I2C. It is worthwhile to investigate these
> Only chips which support SPI/I2C can be used but ISA/PCI is completely
> orthogonal to this AFAIK.

Instead of trying to hook up an ISA chip, go look for the same
function in a SPI/I2C/USB chip.  Almost every peripheral function is
available with many interface choices. Pick one that is more
compatible with your host CPU.

>> serial solutions before doing a parallel solution. Parallel buses eat
>> up a lot of PCB space.
>>
>>
>> >
>> > From Linux driver point of view, what are needed to support an ISA or
>> > PCI driver in ARM architecture?  More important, is ISA or PCI device a
>> > platform device?  If not, how to add these kind of devices in my board
>> > definition?
>> >
>> > I know my question might not be reasonable enough, if I messed concepts,
>> > please sort me out.
>> >
>> >
>> > Thanks in advance.
>> >
>> >
>> > --
>> > woody
>> > I can't go back to yesterday - because I was a different person then.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>
>> --
>> Jon Smirl
>> jonsmirl@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>



--
Jon Smirl
jonsmirl@gmail.com
