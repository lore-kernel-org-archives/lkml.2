Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab0DUEif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 00:38:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:24998 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0DUEie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 00:38:34 -0400
Subject: Re: PCIe hotplug failure
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jeff Newbern <jnewbern@bluespec.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <g2z3c10cdd31004200910y322fd94fn65c548d329104f30@mail.gmail.com>
References: <g2z3c10cdd31004200910y322fd94fn65c548d329104f30@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Apr 2010 22:37:55 -0600
Message-Id: <1271824675.6035.50.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 12:10 -0400, Jeff Newbern wrote:
> Kernel: Ubuntu 9.10 (Karmic) 2.6.31-20-generic
> 
> The pciehp driver is built into the kernel.
> 
> I am connecting a custom FPGA device with a PCIe endpoint through the
> ExpressCard slot on a Lenovo T61 laptop.
> 
> lspci -vv shows HotPlug+ and Surpise+ capabilities for the ExpressCard
> controller.
> 
> I'm running the kernel with pciehp.pciehp_debug=1, and this is the
> dmesg output when I bring up the FPGA device:
> 
> [ 3346.553917] pciehp 0000:00:1c.3:pcie04: pcie_isr: intr_loc 8
> [ 3346.553925] pciehp 0000:00:1c.3:pcie04: Presence/Notify input change
> [ 3346.553934] pciehp 0000:00:1c.3:pcie04: Card present on Slot(5)
> [ 3346.553951] pciehp 0000:00:1c.3:pcie04: Surprise Removal
> [ 3346.553960] pciehp 0000:00:1c.3:pcie04: hpc_get_power_status:
> SLOTCTRL 58 value read 38
> [ 3346.553969] pciehp 0000:00:1c.3:pcie04: hpc_get_attention_status:
> SLOTCTRL 58, value read 38
> [ 3346.554030] pciehp 0000:00:1c.3:pcie04: board_added: slot device,
> slot offset, hp slot = 0, 0, 0
> [ 3347.122566] pciehp 0000:00:1c.3:pcie04: hpc_check_lnk_status:
> lnk_status = 3011
> [ 3347.122685] pci 0000:05:00.0: reg 10 32bit mmio: [0x000000-0x7fffff]
> [ 3347.122708] pci 0000:05:00.0: reg 14 32bit mmio: [0x000000-0x7fffff]
> [ 3347.122743] pci 0000:05:00.0: reg 18 64bit mmio: [0x000000-0x1ffffff]
> [ 3347.122795] pci 0000:05:00.0: reg 30 32bit mmio: [0x000000-0x0fffff]
> [ 3347.122884] pci 0000:05:00.0: PME# supported from D0
> [ 3347.122898] pci 0000:05:00.0: PME# disabled
> [ 3347.122974] pciehp: Could not get hotplug parameters
> [ 3347.123004] pci 0000:05:00.0: BAR 0: can't allocate mem resource
> [0xd6000000-0xd5ffffff]
> [ 3347.123012] pci 0000:05:00.0: BAR 1: can't allocate mem resource
> [0xd6000000-0xd5ffffff]
> [ 3347.123249] pciehp 0000:00:1c.3:pcie04: hpc_get_power_status:
> SLOTCTRL 58 value read 38
> [ 3347.123259] pciehp 0000:00:1c.3:pcie04: hpc_get_attention_status:
> SLOTCTRL 58, value read 38
> 
> The BAR types and sizes look correct in the initial pci lines, but are
> non-sensical in the "can't allocate mem resource" error messages that
> follow the "Could not get hotplug parameters" message.

I added linux-pci, which is more pertinent than lkml.  If you can try a
current upstream kernel and post the entire dmesg log, that would be
useful.  There have been a number of recent changes related to PCI
resource allocation.

Bjorn


