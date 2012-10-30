Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339Ab2J3SX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:23:57 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:53569 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235Ab2J3SXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:23:51 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/3] Add clock framework for armada 370/XP
Date: Tue, 30 Oct 2012 19:23:30 +0100
Message-Id: <1351621413-3637-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

I hope this 4th version will meet your expectations. Beside the
corrections you have asked I also changed the way I get resources for
the clocks. Instead of referring to a node name, now I refer to a
compatible name which should be a better use of the device tree.

Rather than taking this series in your git tree, would it possible to
give your ack to the patches and let Jason Cooper take the patch set
in his git tree. We have other series for mvebu which depend on this
one (SMP, HWIOCC and SATA for now and more to come), and it will be
easier for us to have everything in the same place.

The purpose of this patch set is to add support for clock framework
for Armada 370 and Armada XP SoCs. All the support is done under the
directory drivers/clk/mvebu/ as the support for other mvebu SoCs was
in mind during the writing of the code.

Two kinds of clocks are added:

- The CPU clocks are only for Armada XP (which is multi-core)

- The core clocks are clocks which have their rate fixed during
  reset.

Many thanks to Thomas Petazzoni and Sebastian Hesselbarth for their
review and feedback. The device tree bindings were really improved
with the advices of Sebastian.

Changelog:
V3 -> V4
- Rebased on top of 3.7-rc3
- Replaced the whitespace by tab in the Documentation files
- Fixed the comment style according to the CodingStyle documentation
- Fixed incorrect indentation
- Removed redundant header in clk-cpu.c
- Replaced improper whitespace by tabs in armada-xp.dtsi
- In the device tree, the resources for the clocks do not rely anymore
  on the node name mvebu-sar but now only depend on the compatible
  name. (Issue reported by Sebastian Hesselbarth)

V2 -> V3:
- Rebased on top of v3.7-rc1
- Fixed a typo in device trees
- Fixed warning from checkpatch

V1 -> V2:
- Improved the spelling and the wording of the documentation and the
  1st commit log
- Removed the "end_of_list" name which are unused here.
- Fix the cpu clock by using of_clk_src_onecell_get in the same way it
  was used for the core clocks

Regards,


Gregory CLEMENT (3):
  clk: mvebu: add armada-370-xp specific clocks
  clk: armada-370-xp: add support for clock framework
  clocksource: time-armada-370-xp converted to clk framework

 .../devicetree/bindings/clock/mvebu-core-clock.txt |   40 +++
 .../devicetree/bindings/clock/mvebu-cpu-clock.txt  |   21 ++
 arch/arm/boot/dts/armada-370-db.dts                |    4 -
 arch/arm/boot/dts/armada-370-xp.dtsi               |    1 +
 arch/arm/boot/dts/armada-370.dtsi                  |   12 +
 arch/arm/boot/dts/armada-xp.dtsi                   |   48 +++
 arch/arm/mach-mvebu/Kconfig                        |    5 +
 arch/arm/mach-mvebu/armada-370-xp.c                |    8 +-
 arch/arm/mach-mvebu/common.h                       |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/mvebu/Makefile                         |    2 +
 drivers/clk/mvebu/clk-core.c                       |  318 ++++++++++++++++++++
 drivers/clk/mvebu/clk-core.h                       |   19 ++
 drivers/clk/mvebu/clk-cpu.c                        |  154 ++++++++++
 drivers/clk/mvebu/clk-cpu.h                        |   19 ++
 drivers/clk/mvebu/clk.c                            |   36 +++
 drivers/clocksource/time-armada-370-xp.c           |   11 +-
 17 files changed, 690 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
 create mode 100644 drivers/clk/mvebu/Makefile
 create mode 100644 drivers/clk/mvebu/clk-core.c
 create mode 100644 drivers/clk/mvebu/clk-core.h
 create mode 100644 drivers/clk/mvebu/clk-cpu.c
 create mode 100644 drivers/clk/mvebu/clk-cpu.h
 create mode 100644 drivers/clk/mvebu/clk.c

-- 
1.7.9.5

