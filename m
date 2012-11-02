Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab2KBQVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:21:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56358 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738Ab2KBQVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:21:49 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <b32955@freescale.com>, <shubhrajyoti@ti.com>, <wim@iguana.be>,
        <hs@denx.de>, <nsekhar@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <hdoyu@nvidia.com>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC PATCH 0/2] - Move AEMIF driver out of DaVinci machine 
Date: Fri, 2 Nov 2012 12:21:16 -0400
Message-ID: <1351873278-27325-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DaVinci AEMIF (asynchronous external memory interface) is used on other
TI SoCs that are not DaVinci based. So the AEMIF driver is to be moved
outside mach-davinci to the drivers folder so that it can be re-used on other
TI SoCs. Also migrate the DaVinci NAND driver to use the new
aemif API.

Some of these code has been borrowed from intial patch from Heiko Schocher
 <hs@denx.de>. So I have added his name in the Copyright for davinci-aemif.c
This is an RFC to get the intial response so that all the platforms can
be migrated to use this driver.
 
Murali Karicheri (2):
  memory: davinci - add aemif controller platform driver
  mtd: davinci - remove DaVinci architecture depedency

 .../devicetree/bindings/arm/davinci/aemif.txt      |   62 +++
 drivers/memory/Kconfig                             |   10 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/davinci-aemif.c                     |  397 ++++++++++++++++++++
 drivers/mtd/nand/Kconfig                           |    6 +-
 drivers/mtd/nand/davinci_nand.c                    |   40 +-
 include/linux/platform_data/davinci-aemif.h        |   47 +++
 include/linux/platform_data/davinci-nand.h         |   87 +++++
 8 files changed, 624 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/davinci/aemif.txt
 create mode 100644 drivers/memory/davinci-aemif.c
 create mode 100644 include/linux/platform_data/davinci-aemif.h
 create mode 100644 include/linux/platform_data/davinci-nand.h

-- 
1.7.9.5

