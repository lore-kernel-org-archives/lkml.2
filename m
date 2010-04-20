Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0DTQKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:10:48 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:57731 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0DTQKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:10:47 -0400
MIME-Version: 1.0
From: Jeff Newbern <jnewbern@bluespec.com>
Date: Tue, 20 Apr 2010 12:10:26 -0400
Message-ID: <g2z3c10cdd31004200910y322fd94fn65c548d329104f30@mail.gmail.com>
Subject: PCIe hotplug failure
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: Ubuntu 9.10 (Karmic) 2.6.31-20-generic

The pciehp driver is built into the kernel.

I am connecting a custom FPGA device with a PCIe endpoint through the
ExpressCard slot on a Lenovo T61 laptop.

lspci -vv shows HotPlug+ and Surpise+ capabilities for the ExpressCard
controller.

I'm running the kernel with pciehp.pciehp_debug=1, and this is the
dmesg output when I bring up the FPGA device:

[ 3346.553917] pciehp 0000:00:1c.3:pcie04: pcie_isr: intr_loc 8
[ 3346.553925] pciehp 0000:00:1c.3:pcie04: Presence/Notify input change
[ 3346.553934] pciehp 0000:00:1c.3:pcie04: Card present on Slot(5)
[ 3346.553951] pciehp 0000:00:1c.3:pcie04: Surprise Removal
[ 3346.553960] pciehp 0000:00:1c.3:pcie04: hpc_get_power_status:
SLOTCTRL 58 value read 38
[ 3346.553969] pciehp 0000:00:1c.3:pcie04: hpc_get_attention_status:
SLOTCTRL 58, value read 38
[ 3346.554030] pciehp 0000:00:1c.3:pcie04: board_added: slot device,
slot offset, hp slot = 0, 0, 0
[ 3347.122566] pciehp 0000:00:1c.3:pcie04: hpc_check_lnk_status:
lnk_status = 3011
[ 3347.122685] pci 0000:05:00.0: reg 10 32bit mmio: [0x000000-0x7fffff]
[ 3347.122708] pci 0000:05:00.0: reg 14 32bit mmio: [0x000000-0x7fffff]
[ 3347.122743] pci 0000:05:00.0: reg 18 64bit mmio: [0x000000-0x1ffffff]
[ 3347.122795] pci 0000:05:00.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[ 3347.122884] pci 0000:05:00.0: PME# supported from D0
[ 3347.122898] pci 0000:05:00.0: PME# disabled
[ 3347.122974] pciehp: Could not get hotplug parameters
[ 3347.123004] pci 0000:05:00.0: BAR 0: can't allocate mem resource
[0xd6000000-0xd5ffffff]
[ 3347.123012] pci 0000:05:00.0: BAR 1: can't allocate mem resource
[0xd6000000-0xd5ffffff]
[ 3347.123249] pciehp 0000:00:1c.3:pcie04: hpc_get_power_status:
SLOTCTRL 58 value read 38
[ 3347.123259] pciehp 0000:00:1c.3:pcie04: hpc_get_attention_status:
SLOTCTRL 58, value read 38

The BAR types and sizes look correct in the initial pci lines, but are
non-sensical in the "can't allocate mem resource" error messages that
follow the "Could not get hotplug parameters" message.

I haven't been able to find useful information on this particular
problem through Google, the Ubuntu forums or at the Linux Hardware
Compatibility site.  Does anyone know what is causing this problem or
have pointers on debugging it?  I have a lot more data available
(dmesg logs, lspci output, etc), but I didn't want to waste bandwidth
with it unless someone indicated a desire to see it.  My ultimate goal
is to be able to power up, power down, and reprogram the FPGA and have
the device configured correctly and the device driver automatically
loaded, unloaded, and reloaded as required.

Thank you,
Jeff Newbern
