Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab1EON0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:26:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368Ab1EON0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:26:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: pci 0000:0a:00.0: Refused to change power state, currently in D3
Date: Sun, 15 May 2011 15:26:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <936833.81097.qm@web161805.mail.bf1.yahoo.com>
In-Reply-To: <936833.81097.qm@web161805.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151526.41801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011, Mikko Vinni wrote:
> Hi,

Hi,

> in an HP Pavilion dv5 laptop model dv5-1250eo always at resume
> from s2ram the following messages are printed:
> 
> pci 0000:0a:00.0: Refused to change power state, currently in D3
> pci 0000:0a:00.1: Refused to change power state, currently in D3
> pci 0000:0a:00.2: Refused to change power state, currently in D3
> pci 0000:0a:00.3: Refused to change power state, currently in D3
> pci 0000:0a:00.4: Refused to change power state, currently in D3

The lspci output indicates that this is a single multi-function
device that doesn't change its power state when programmed to go
into D0.  Perhaps it requires a power resource that is not available
at the point we're trying to restore those devices' registers.

Hard to say what that may be, though.  Please attach the output of
acpidump from the affected system.

> 
> 
> lspci:
> 
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
> 00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0)
> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
> 00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
> 00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
> 00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (PCIE port 5)
> 00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
> 00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:12.1 USB Controller: ATI Technologies Inc SB7x0 USB OHCI1 Controller
> 00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:13.1 USB Controller: ATI Technologies Inc SB7x0 USB OHCI1 Controller
> 00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
> 00:14.1 IDE interface: ATI Technologies Inc SB7x0/SB8x0/SB9x0 IDE Controller
> 00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
> 00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller
> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor HyperTransport Configuration (rev 40)
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Link Control
> 01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3400 Series
> 01:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon HD 34xx Series]
> 08:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
> 09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 0a:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller
> 0a:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
> 0a:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller
> 0a:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
> 0a:00.4 System peripheral: JMicron Technology Corp. xD Host Controller
> 
> 
> (first reported to linux-mmc at http://thread.gmane.org/gmane.linux.kernel.mmc/7988,
> because the card reader is one of the non-functioning devices after resume)
> 
> What could be causing such a problem?
> 
> The following log is from 2.6.39-rc7 + some code from mmc-next, but this
> is not a new problem. I can reproduce it easily for example with the
> default 2.6.32 kernel from Ubuntu 10.10.
...
> 
> 
> A perhaps funny after-effect of the s2ram problem is that
> s2disk after that leads to -1 being written all around
> in the affected pci area after resume:
> 
> ...
> ACPI: Waking up from system sleep state S4
> ...
> pci 0000:0a:00.0: restoring config space at offset 0xf (was 0x10a, writing 0xffffffff)
> pci 0000:0a:00.0: restoring config space at offset 0xe (was 0x0, writing 0xffffffff)
> ...

That's not even strange.  Since the device is in D3 during hibernation,
the reads from its registers all return -1 and that's what is saved as the
current state.

> I haven't tested whether firewire or the card reader, for example, works
> with such config space.

No, it's not.

Thanks,
Rafael
