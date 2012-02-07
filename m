Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2BGIvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:51:45 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:33748 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2BGIvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:51:43 -0500
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 03:51:43 EST
Date: Tue, 7 Feb 2012 09:40:37 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.2.5
Message-ID: <20120207084037.GA6140@citd.de>
References: <20120206181622.GA28811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206181622.GA28811@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.02.2012 10:16, Greg KH wrote:
> I'm announcing the release of the 3.2.5 kernel.
> 
> It contains one PCI patch, it is up to you to decide to upgrade or not.

This one makes my Soundblaster Live (alsa/emu10k1) silent.
It is detected, i can e.g. change the mixer, but i can't hear any sound.

Updating from 3.2.4 the emu10k1 driver was among the few that was 
recompiled after the update to 3.2.5. (Technically i look for that when 
i downgraded to 3.2.4, but i think there number of recompiled files 
should be the same in either direction)

After downgrade to 3.2.4 i have sound again.

There is a difference in syslog output regarding aspm, the emu10k1 line 
is the same.

3.2.4:
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
...
ACPI _OSC control for PCIe not granted, disabling ASPM
...
e1000e 0000:03:00.0: Disabling ASPM  L1
...
snd_emu10k1 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16


3.2.5:
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
..
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
...
pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
...
ACPI _OSC control for PCIe not granted, disabling ASPM
...
e1000e 0000:03:00.0: Disabling ASPM  L1
...
snd_emu10k1 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16


The Mainboard is a Cougar Point H67 Chipset: Gigabyte H67A-UD3H-B3.
CPU is Core Intel i7-2600.

lspci:
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)
00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5)
00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 7 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5)
00:1f.0 ISA bridge: Intel Corporation H67 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
03:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
05:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 10)
06:02.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 0a)
06:02.1 Input device controller: Creative Labs SB Live! Game Port (rev 0a)

lspci -t:
-[0000:00]-+-00.0
           +-01.0-[01]----00.0
           +-02.0
           +-16.0
           +-1a.0
           +-1b.0
           +-1c.0-[02]--
           +-1c.4-[03]----00.0
           +-1c.5-[04]----00.0
           +-1c.6-[05-06]----00.0-[06]--+-02.0
           |                            \-02.1
           +-1d.0
           +-1e.0-[07]--
           +-1f.0
           +-1f.2
           \-1f.3


If there is more than can i do, i'm happy to give more details/try 
patches ...





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

