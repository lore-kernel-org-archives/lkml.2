Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2CJNZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 08:25:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40692 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2CJNZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 08:25:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120310130055.5bd5263a@pyramind.ukuu.org.uk>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
	<CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
	<20120310130055.5bd5263a@pyramind.ukuu.org.uk>
Date: Sat, 10 Mar 2012 13:25:21 +0000
Message-ID: <CAPweEDx3ktAgz9vdM+E-c5YZGrbBMbX4TOy+QUHV3mRM28oWRw@mail.gmail.com>
Subject: Re: [advice sought] EOMA68 kernel support
From: lkcl luke <luke.leighton@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 1:00 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sat, 10 Mar 2012 06:45:15 +0000
> lkcl luke <luke.leighton@gmail.com> wrote:
>
>> On Fri, Mar 9, 2012 at 10:41 PM, lkcl luke <luke.leighton@gmail.com> wrote:
>>
>> > the implications of that split, for the linux kernel source code, are
>> > a bit... scarey :)
>>
>>  ... so, real simple very basic, concrete and necessary question:
>> where the hell in the linux kernel tree should support for eoma68 be
>> added??
>
> It sounds to me like a bus.

 *click*... good point!  ok, it's a collection of
decade-long-established Lowest Common Denominator buses.

>>  * driver support can't be added to drivers/ because although a device
>> with an EOMA68 CPU card *requires* drivers, it's not *actual* drivers
>> being added, it's driver *grouping* code that's required, and that
>> concept simply does... not... exist.
>
> Actually we stick busses in drivers too (see pci...)

 ah, doh, of course.  drivers/usb etc.  right, yep - that works.

>> very basic question.  where the hell should EOMA support source code go?
>>
>> bearing in mind that the first CPU card is an Allwinner A10, the next
>> one is likely to be an AMD Fusion, the one after that could be from
>> icubecorp, the one after that a multi-core SMP xtensa, etc.
>
> Off the top of my head I suspect you want
>
> drivers/eoma68/
>
> which is the bus interface and glue including reading the device tree
> data for the current board you are plugged into and building a device
> tree from that.


> lib/eoma68

 right - yep: i'd missed lib. that also makes sense.

> or some similar name, which is the library routines everything using
> eoma68 needs
>
> arch/[x86.arm,..]/platform/eoma68/..
>
> probably the platform code for each system.

 yep.  that'd work too.  eyy, sorted!


> I don't btw see the problem with your device trees and display.

 my experience with the linux kernel source dates back to 2.4.20,
2.6.12, 2.6.16, then more recently 2.6.26, so it predates device tree:
i may therefore just be lacking confidence in the ability of device
tree to solve the problem, whereas you're not :)  *takes hat off and
bows with a respectful but cheeky grin* :)

 of particular concern is that a CPU card could be running on (small!)
backup battery / supercapacitor whilst being hot-swapped, and thus
that means that the LCD module (drivers/eoma68/lcd.ko?) would need to
be loaded and unloaded from userspace (udev).  that's not going to be
a problem, is it?  i may just be imagining skeletons in the closet,
here.

 oo, bugger.  backlight control.  damn.  each I/O board is going to
potentially have entirely different backlight control characteristics
and drivers.  if there is one at all.

> If you've
> got a device tree on *both* the CPU card and the I/O boards then you've
> got all the data in the right places.

 yes, that's the plan.

 * for the fixed "bus group" (SATA, ETH, I2C, USB2) there would be a
device-tree (somewhat overkill, but that's ok) which ends up on the
NAND flash of the CPU card.  it's not going to change, that's the main
thing.

 * it's the purposes to which the 16 GPIOs can be put that will be
radically different from one I/O board to the next.  GPIO 0 could be
"powerup for WIFI" on one I/O board, but "lid open/shut switch" on
another.

so, each I/O board needs to have a set of definitions which have
*nothing* to do with the CPU Card which will get plugged into them.

it's all a bit... weird.

but the whole strategy is based around solving this ridiculous
situation of having to create platform-specific drivers for every
single bloody device, irrespective of the CPU being used, N*M where N
= CPU and M = type of computer, and replacing it with an
N+M+small-common-overhead codebase.

thanks alan.

l.
