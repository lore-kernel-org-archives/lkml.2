Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319Ab2FBDaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 23:30:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65390 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab2FBDai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 23:30:38 -0400
Message-ID: <4FC988CF.5030602@gmail.com>
Date: Sat, 02 Jun 2012 11:30:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bill Unruh <unruh@physics.ubc.ca>, Bjorn Helgaas <bhelgaas@google.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic Toughbook
 S10
References: <Pine.LNX.4.64.1205311412210.11510@info> <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com> <Pine.LNX.4.64.1206010915580.26561@info>
In-Reply-To: <Pine.LNX.4.64.1206010915580.26561@info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill and Bjorn,
	Device 8086:0103 is "2nd Generation Core Processor Family Thermal Management
Controller" or "Sandy Bridge Thermal Management Controller". And address range 
0xfed98000-0xfed9ffff has been reserved by motherboard device(PNP0C02). 
	I guess that BIOS has assigned address "0xfed98000" to 0000:00:04.0 for
thermal management functionality. The BAR0 of 0000:00:04.0 may be locked down 
(can't be changed by OS) because the ACPI BIOS may have dependency on the assigned
address ranges. A ACPI dump may give some help here if convenient.
	Thanks!
	Gerry

On 06/02/2012 12:22 AM, Bill Unruh wrote:
> Attached is a complete dmesg from a bootup of the kernel on the toughbook S10.
> 
> 
> RE the noapic, I have no idea how I can give more information on it, since the
> crash almost always occurs during the boot process itself, often very early in
> the process. I will see if I can resurect the dmesg that gets saved, if any,
> during that process. It is probably also an earlier kernel. I have not dared
> try my current kernel with noapic, but perhaps I will try.
> 
> 
> 
> On Fri, 1 Jun 2012, Bjorn Helgaas wrote:
> 
>> On Thu, May 31, 2012 at 3:39 PM, Bill Unruh <unruh@physics.ubc.ca> wrote:
>>> I am running Mageia 2 kernel 3.3.6-desktop586-2.mga2
>>>
>>> Every time I boot up I get the error messages
>>> pci 0000:00:04.0: BAR 0: error updating (0xdfa00004 != 0xfed98004)
>>
>> Thanks very much for this report.  I opened this bug report to help me
>> keep track of it: https://bugzilla.kernel.org/show_bug.cgi?id=43331
>>
>> The message means that we tried to write address 0xdfa00000 to BAR 0
>> of device 00:04.0 (a "signal processing controller," whatever that
>> is), but when we read the BAR back, we read 0xfed98004 instead.
>> That's an interesting address because it looks a lot like a resource
>> of an ACPI PNP0c02 device:
>>
>>  system 00:0e: [mem 0xfed98000-0xfed9ffff] has been reserved
>>  system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
>>
>> You say your machine runs OK (with "noapic"), but I'm doubtful that
>> 00:04.0 is working -- it doesn't even seem to have a driver bound to
>> it.  I don't know what the device does, but if you're not using it,
>> it's not surprising that you wouldn't notice it being broken.
>>
>> Can you attach the complete dmesg log to the bugzilla?  It will have
>> more details about other devices and the ranges from which we allocate
>> resources for PCI devices.
>>
>> You mention that the machine is not reliable unless you use "noapic".
>> That sounds like a separate bug, but also something it would be good
>> to track down.
>>
> 

