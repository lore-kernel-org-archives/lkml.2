Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1JHSON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:14:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37065 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1JHSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6CH-FHOughZu3KSsRYHX2dvncB1sFBNVp+ivEHNs52yA@mail.gmail.com>
References: <CAHFNz9L-WDeEGx9MazTawJF-Hsz88FS7Z=RinfrKn780jBf++A@mail.gmail.com>
	<CAErSpo6CH-FHOughZu3KSsRYHX2dvncB1sFBNVp+ivEHNs52yA@mail.gmail.com>
Date: Sat, 8 Oct 2011 23:44:10 +0530
Message-ID: <CAHFNz9+pQX8O6FAOpiNVDJbn82i7VWv6hBr6+6E_9QnvuAUGEw@mail.gmail.com>
Subject: Re: Memory at xxxxxx [disabled]
From: Manu Abraham <abraham.manu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/11, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Oct 8, 2011 at 9:51 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Hi,
>>
>> Any Idea why I am seeing the [disabled] for the specified memory
>> region as described below ?
>>
>> 04:07.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
>> Device [1822:4e31] (rev 01)
>>        Subsystem: Twinhan Technology Co. Ltd Device [1822:0010]
>>        Flags: medium devsel, IRQ 11
>>        Memory at fd900000 (32-bit, prefetchable) [disabled] [size=4K]
>
> The complete dmesg log should have some clues.  Normally we use the
> resources assignments done by BIOS.


While waiting for a reply, I did a few reboots down the lane, no
changes made by me, except that I plugged the card into the next PCI
slot ..

I am abit more perplexed now .. The device doesn't show "disabled" but
shows a different device ID which is the correct one, as you can see,
compared to earlier ..


04:06.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: Twinhan Technology Co. Ltd Device [1822:0014]
        Flags: bus master, medium devsel, latency 32, IRQ 11
        Memory at fd9ff000 (32-bit, prefetchable) [size=4K]

testbox test-apps # lspci -tv
-[0000:00]-+-00.0  Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
           +-01.0-[01]--+-05.0  ATI Technologies Inc Device 9710
           |            \-05.1  ATI Technologies Inc Device 970f
           +-04.0-[02]----00.0  Philips Semiconductors Device 7160
           +-0a.0-[03]----00.0  Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller
           +-11.0  ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
           +-12.0  ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
           +-12.1  ATI Technologies Inc SB700 USB OHCI1 Controller
           +-12.2  ATI Technologies Inc SB700/SB800 USB EHCI Controller
           +-13.0  ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
           +-13.1  ATI Technologies Inc SB700 USB OHCI1 Controller
           +-13.2  ATI Technologies Inc SB700/SB800 USB EHCI Controller
           +-14.0  ATI Technologies Inc SBx00 SMBus Controller
           +-14.1  ATI Technologies Inc SB700/SB800 IDE Controller
           +-14.2  ATI Technologies Inc SBx00 Azalia (Intel HDA)
           +-14.3  ATI Technologies Inc SB700/SB800 LPC host controller
           +-14.4-[04]----06.0  Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0]
           +-14.5  ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
           +-18.0  Advanced Micro Devices [AMD] K10 [Opteron,
Athlon64, Sempron] HyperTransport Configuration
           +-18.1  Advanced Micro Devices [AMD] K10 [Opteron,
Athlon64, Sempron] Address Map
           +-18.2  Advanced Micro Devices [AMD] K10 [Opteron,
Athlon64, Sempron] DRAM Controller
           +-18.3  Advanced Micro Devices [AMD] K10 [Opteron,
Athlon64, Sempron] Miscellaneous Control
           \-18.4  Advanced Micro Devices [AMD] K10 [Opteron,
Athlon64, Sempron] Link Control


Could it be that the PCI BIST took more time or something of that
sort, for the EEPROM upload, in the problematic case as earlier
(seeing some users complained about bogus device ID's similarly in the
past. Can't be a corrupt EEPROM either, since it returned to normal a
few reboots down the lane, or in a different PCI slot) ?


Thanks,
Manu
