Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2CID0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:26:00 -0500
Received: from ozlabs.org ([203.10.76.45]:43488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2CIDZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:25:59 -0500
Date: Fri, 9 Mar 2012 14:25:55 +1100
From: Anton Blanchard <anton@samba.org>
To: sfr@ozlabs.org, benh@kernel.crashing.org, yinghai@kernel.org,
        jbarnes@virtuousgeek.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: 3.3.0-rc6-next-20120308 boot failure on POWER7 blade
Message-ID: <20120309142555.7ec5e0ac@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm seeing this on a POWER7 blade booting 3.3.0-rc6-next-20120308:


PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x100000-0x10ffff] (bus address [0xf0000-0xfffff])
pci_bus 0000:00: root bus resource [mem 0x3b0000000000-0x3b001fffffff] (bus address [0xe0000000-0xffffffff])
IOMMU table initialized, virtual merging enabled
PCI host bridge to bus 0001:00
pci_bus 0001:00: root bus resource [io  0x210000-0x21ffff] (bus address [0xf0000-0xfffff])
pci_bus 0001:00: root bus resource [mem 0x3b0080000000-0x3b00ffffffff] (bus address [0x80000000-0xffffffff])
PCI host bridge to bus 0002:01
pci_bus 0002:01: root bus resource [io  0x320000-0x32ffff] (bus address [0xf0000-0xfffff])
pci_bus 0002:01: root bus resource [mem 0x3b0400000000-0x3b041fefffff] (bus address [0xe0000000-0xffefffff])
PCI: Cannot allocate resource region 0 of device 0000:00:01.0, will remap
PCI: Cannot allocate resource region 2 of device 0000:00:01.0, will remap
PCI: Cannot allocate resource region 6 of device 0000:00:01.0, will remap
PCI: Cannot allocate resource region 0 of device 0001:00:01.0, will remap
PCI: Cannot allocate resource region 0 of device 0001:00:01.1, will remap
PCI: Cannot allocate resource region 0 of device 0001:00:01.2, will remap
PCI: Cannot allocate resource region 0 of device 0002:01:00.0, will remap
PCI: Cannot allocate resource region 2 of device 0002:01:00.0, will
remap

...

pci 0001:00:01.0: device not available (can't reserve [mem 0x00000000-0x00000fff])
pci 0001:00:01.0: Can't enable PCI device, BIOS handoff failed.
pci 0001:00:01.1: device not available (can't reserve [mem 0x00000000-0x00000fff])
pci 0001:00:01.1: Can't enable PCI device, BIOS handoff failed.
pci 0001:00:01.2: device not available (can't reserve [mem 0x00000000-0x000000ff])
pci 0001:00:01.2: Can't enable PCI device, BIOS handoff failed.


Then we fail to find the root device. I haven't had a chance
to chase the cause of it down yet.

Anton
