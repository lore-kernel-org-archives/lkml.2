Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2KFVre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:47:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48076 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KFVrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:47:31 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <hs@denx.de>, <nsekhar@ti.com>, <mikedunn@newsguy.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <hdoyu@nvidia.com>, <santosh.shilimkar@ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC v2 PATCH 0/2]Move AEMIF driver out of DaVinci machine to memory subsystem
Date: Tue, 6 Nov 2012 16:47:05 -0500
Message-ID: <1352238427-26085-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the comments addressed in this patch vs initial version are
 1. moved the bindings documentation to bindings/memory/davinci-aemif.txt
 2. moved the bindings documentation for nand to mtd/ folder
 3. renamed cs subnode fields with a ti,davinci-cs prefix.
 4. davinci-aemif.txt now has full picture of aemif async bus bindings
    and that of all of the sub device nodes and sub nodes
 5. Made cs node optional so that on platforms that sets the cs
    parameters in bootloader can ignore the cs binding nodes so that
    hardware values set by boot loader is used.

The DaVinci AEMIF (asynchronous external memory interface) is used on other
TI SoCs that are not DaVinci based. So the AEMIF driver is to be moved
outside mach-davinci to the drivers folder so that it can be re-used on other
TI SoCs. Also migrate the DaVinci NAND driver to use the new aemif API.

Some of these code has been borrowed from intial patch from Heiko Schocher
 <hs@denx.de>. So I have added his name in the Copyright for davinci-aemif.c
This is an RFC to get the intial response so that all the platforms can
be migrated to use this driver.

Murali Karicheri (2):
  memory: davinci - add aemif controller platform driver
  mtd: davinci - remove DaVinci architecture depedency

 .../devicetree/bindings/arm/davinci/nand.txt       |   59 ---
 .../devicetree/bindings/memory/davinci-aemif.txt   |  103 +++++
 .../devicetree/bindings/mtd/davinci-nand.txt       |   59 +++
 drivers/memory/Kconfig                             |   10 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/davinci-aemif.c                     |  479 ++++++++++++++++++++
 drivers/mtd/nand/Kconfig                           |    6 +-
 drivers/mtd/nand/davinci_nand.c                    |   40 +-
 include/linux/platform_data/davinci-aemif.h        |   47 ++
 include/linux/platform_data/davinci-nand.h         |   87 ++++
 10 files changed, 806 insertions(+), 85 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/memory/davinci-aemif.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt
 create mode 100644 drivers/memory/davinci-aemif.c
 create mode 100644 include/linux/platform_data/davinci-aemif.h
 create mode 100644 include/linux/platform_data/davinci-nand.h

-- 
1.7.9.5

