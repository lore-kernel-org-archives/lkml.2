Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab2JaRje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:39:34 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:34547 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933036Ab2JaRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:39:29 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Paul Walmsley <paul@pwsan.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [RFC-v2 0/7] Capebus; a bus for SoCs using simple expansion connectors
Date: Thu,  1 Nov 2012 17:32:25 +0200
Message-Id: <1351783952-11804-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capebus is created to address the problem of many SoCs that can provide a
multitude of hardware interfaces but in order to keep costs down the main
boards only support a limited number of them. The rest are typically brought
out to pin connectors on to which other boards, named capes are connected and
allow those peripherals to be used.

These capes connect to the SoC interfaces but might also contain various other
parts that may need some kind of driver to work.

Since SoCs have limited pins and pin muxing options, not all capes can work
together so some kind of resource tracking (at least for the pins in use) is
required.

Before capebus all of this took place in the board support file, and frankly
for boards with too many capes it was becoming unmanageable.

Capebus provides a virtual bus, which along with a board specific controller,
cape drivers can be written using the standard Linux device model.

The core capebus infrastructure is not depended on any specific board.
However capebus needs a board controller to provide services to the cape devices
it controls. Services like addressing and resource reservation are provided
by the board controller.

Capebus at the moment only support TI's Beaglebone platform.

This RFC introduces the core concept; most supporting patches
have been posted to the relevant places.

If you have a beaglebone and want to check it out, you can do
so at:

git://github.com/pantoniou/linux-bbxm.git branch capebus-v4

Changes from RFC-v1:

The omap_platform device build has been moved out of capebus
and placed in their proper place in arch/arm/mach-omap2

Pantelis Antoniou (7):
  capebus: Core capebus support
  capebus: Add beaglebone board support
  capebus: Beaglebone generic cape support
  capebus: Beaglebone geiger cape support
  capebus: Beaglebone capebus DT update
  capebus: Document DT bindings
  capebus: Documentation; capebus-summary

 Documentation/capebus/capebus-summary              |  40 +
 .../capebus/bone-capebus-slot-override.txt         |  28 +
 .../devicetree/bindings/capebus/bone-capebus.txt   |  50 ++
 .../bindings/capebus/bone-geiger-cape.txt          |  78 ++
 .../bindings/capebus/bone-generic-cape.txt         |  97 +++
 .../devicetree/bindings/capebus/da8xx-dt.txt       |  31 +
 .../devicetree/bindings/capebus/i2c-dt.txt         |  42 +
 .../devicetree/bindings/capebus/spi-dt.txt         |  37 +
 .../devicetree/bindings/capebus/ti-tscadc-dt.txt   |  34 +
 arch/arm/boot/dts/am335x-bone-common.dtsi          | 689 ++++++++++++++-
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   3 +
 drivers/capebus/Kconfig                            |  17 +
 drivers/capebus/Makefile                           |   8 +
 drivers/capebus/boards/Kconfig                     |   6 +
 drivers/capebus/boards/Makefile                    |   3 +
 drivers/capebus/boards/capebus-bone-generic.c      | 237 ++++++
 drivers/capebus/boards/capebus-bone-pdevs.c        | 328 ++++++++
 drivers/capebus/boards/capebus-bone.c              | 931 +++++++++++++++++++++
 drivers/capebus/capebus-driver.c                   | 608 ++++++++++++++
 drivers/capebus/capebus-probe.c                    | 320 +++++++
 drivers/capebus/capebus-sysfs.c                    |  52 ++
 drivers/capebus/capes/Kconfig                      |  13 +
 drivers/capebus/capes/Makefile                     |   2 +
 drivers/capebus/capes/bone-geiger-cape.c           | 517 ++++++++++++
 drivers/capebus/capes/bone-generic-cape.c          |  75 ++
 include/linux/capebus.h                            | 298 +++++++
 include/linux/capebus/capebus-bone.h               | 120 +++
 28 files changed, 4636 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/capebus/capebus-summary
 create mode 100644 Documentation/devicetree/bindings/capebus/bone-capebus-slot-override.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/bone-capebus.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/bone-geiger-cape.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/bone-generic-cape.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/da8xx-dt.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/i2c-dt.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/spi-dt.txt
 create mode 100644 Documentation/devicetree/bindings/capebus/ti-tscadc-dt.txt
 create mode 100644 drivers/capebus/Kconfig
 create mode 100644 drivers/capebus/Makefile
 create mode 100644 drivers/capebus/boards/Kconfig
 create mode 100644 drivers/capebus/boards/Makefile
 create mode 100644 drivers/capebus/boards/capebus-bone-generic.c
 create mode 100644 drivers/capebus/boards/capebus-bone-pdevs.c
 create mode 100644 drivers/capebus/boards/capebus-bone.c
 create mode 100644 drivers/capebus/capebus-driver.c
 create mode 100644 drivers/capebus/capebus-probe.c
 create mode 100644 drivers/capebus/capebus-sysfs.c
 create mode 100644 drivers/capebus/capes/Kconfig
 create mode 100644 drivers/capebus/capes/Makefile
 create mode 100644 drivers/capebus/capes/bone-geiger-cape.c
 create mode 100644 drivers/capebus/capes/bone-generic-cape.c
 create mode 100644 include/linux/capebus.h
 create mode 100644 include/linux/capebus/capebus-bone.h

-- 
1.7.12

