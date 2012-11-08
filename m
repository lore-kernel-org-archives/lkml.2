Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2KHT4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:56:25 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:51872 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2KHTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:19 -0500
Message-Id: <cover.1352400580.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>, John Linn <john.linn@xilinx.com>,
        arm@kernel.org
Date: Thu, 8 Nov 2012 12:49:40 -0600
Subject: [PATCH v2 0/5] zynq clk support
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize complete at 11/08/2012 01:54:07 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-08_04:2012-11-08,2012-11-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set is a v2 of my original patchset "zynq COMMON_CLK support" [1].

This patchset is on top of the arm-next in the Xilinx tree[2], and also
dependent on my patch "serial: xilinx_uartps: kill CONFIG_OF
conditional", which I've removed from this patchset at Michal Simek's request.

For easy testing, I've made available a branch with my changes here[3].

Changes since v1:
  - Dropped the moving of the TTC driver.  This will be done in a later
    patchset.
  - Fixed TTC periodic tick frequency calculation
  - Updated basic peripheral clk to support devices with less than two
    derivative clks.
  - Fixed dts issues in the uart and ttc (thanks to Lars-Peter Clausen and Michal Simek).
  - Split out the creation of the clk drivers and the enabling of the
    drivers for the platform into separate patches.
  - Updated clk initialization functions to 'bail out' when an error
    condition is hit.
  - Addressed stylistic feedback from Lars-Peter Clausen.

---
Patch 1 performs a dts file split for zynq, creating a generic zynq-7000.dtsi
snippet and a zynq-zc702.dts board specific description.

Patch 2 introduces the zynq clock drivers and bindings.

Patch 3 enables the zynq clock drivers when building for zynq, and
adds updates the zynq device trees to use the bindings.

Patch 4 updates the xilinx uartps driver to acquire rate information via
the clk bindings.

Patch 5 updates the xilinx ttc driver to acquire rate information via
the clk bindings.

---
[1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2012-October/129295.html
[2]: git://git.xilinx.com/linux-xlnx.git#arm-next
[3]: git://gi.teric.us/linux-zynq.git#of_clk_v2
---
Josh Cartwright (5):
  ARM: zynq: dts: split up device tree
  clk: Add support for fundamental zynq clks
  ARM: zynq: use zynq clk bindings
  serial: xilinx_uartps: get clock rate info from dts
  ARM: zynq: add clk binding support to the ttc

 .../devicetree/bindings/clock/zynq-7000.txt        |  55 +++
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/zynq-7000.dtsi                   | 166 +++++++++
 arch/arm/boot/dts/zynq-ep107.dts                   |  70 ----
 arch/arm/boot/dts/zynq-zc702.dts                   |  44 +++
 arch/arm/mach-zynq/common.c                        |  14 +-
 arch/arm/mach-zynq/timer.c                         | 287 ++++++++-------
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-zynq.c                             | 383 +++++++++++++++++++++
 drivers/tty/serial/xilinx_uartps.c                 |  30 +-
 include/linux/clk/zynq.h                           |  24 ++
 12 files changed, 870 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/zynq-7000.txt
 create mode 100644 arch/arm/boot/dts/zynq-7000.dtsi
 delete mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/boot/dts/zynq-zc702.dts
 create mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 include/linux/clk/zynq.h

-- 
1.8.0

