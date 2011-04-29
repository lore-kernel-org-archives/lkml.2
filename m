Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1D2HPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:15:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45645 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1D2HPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:15:30 -0400
Subject: [PATCH v5 0/8] Basic ARM devicetree support
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Fri, 29 Apr 2011 01:15:27 -0600
Message-ID: <20110429070135.12522.35745.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it's been a while since I've posted these, so it's probably
about time to circulate them again.

v5 rebases on top of 2.6.39-rc5 plus one patch to allow arch code
to pass in a pointer to the command_line buffer, and the virq rework
series that (finally!) implements devicetree irq mapping support for
all architectures.  All prerequisite patches were posted earlier today,
I've also pushed them out to:

    git://git.secretlab.ca/git/linux-2.6 devicetree/irq-domain.

Patch 5 in this series cleans up for the irq-domain change, but this
series can be used on a vanilla 2.6.39-rc5 by dropping patch #5, and
adding the cmd_line prerequisite patch.

Both devicetree/arm and devicetree/test branches on
git://git.secretlab.ca/git/linux-2.6 reflect the current state of this
patch series (although there is all kinds of crud committed on top of
them in devicetree/test)

I'm not asking for these patches to be merged into mainline yet, but
I'm fairly confident that they should be pretty close to their final
form.

Please test.

Thanks,
g.

---

 This patch series allows CONFIG_OF to be enabled on ARM and allows the
 kernel to accept a dtb pointer from boot firmware instead of atags.
 If a dtb is passed, then the kernel will use the root 'compatible'
 property to find a matching machine_desc, and it will use it to obtain
 the memory layout, initrd location and kernel parameters string.

 Only limited device tree support is enabled here.  It does not perform
 any kind of device registration from device tree data.  That support
 will be enabled in a later patch set.  Rather, this series is a stable
 base that other engineers can use to start working on device tree
 support for their platforms.

---

Grant Likely (8):
      arm/dt: Make __vet_atags also accept a dtb image
      arm/dt: Allow CONFIG_OF on ARM
      arm/dt: consolidate atags setup into setup_machine_atags
      arm/dt: probe for platforms via the device tree
      arm/dt: Drop irq_create_of_mapping() from arm code.
      arm/dt: Basic versatile devicetree support
      arm/dt: Basic tegra devicetree support
      dt: add documentation of ARM dt boot interface


 Documentation/arm/Booting                       |   33 +++++-
 Documentation/devicetree/booting-without-of.txt |   48 ++++++++
 arch/arm/Kconfig                                |    7 +
 arch/arm/boot/dts/omap4-panda.dts               |   11 ++
 arch/arm/boot/dts/skeleton.dtsi                 |   13 ++
 arch/arm/boot/dts/tegra-harmony.dts             |    7 +
 arch/arm/boot/dts/versatile-ab.dts              |    7 +
 arch/arm/boot/dts/versatile-pb.dts              |    7 +
 arch/arm/include/asm/mach/arch.h                |    9 ++
 arch/arm/include/asm/prom.h                     |   37 ++++++
 arch/arm/include/asm/setup.h                    |    4 +
 arch/arm/kernel/Makefile                        |    1 
 arch/arm/kernel/devtree.c                       |  131 +++++++++++++++++++++++
 arch/arm/kernel/head-common.S                   |   24 +++-
 arch/arm/kernel/head.S                          |    8 +
 arch/arm/kernel/setup.c                         |   90 ++++++++++------
 arch/arm/mach-omap2/board-omap4panda.c          |    6 +
 arch/arm/mach-tegra/board-harmony.c             |    6 +
 arch/arm/mach-versatile/versatile_ab.c          |    6 +
 arch/arm/mach-versatile/versatile_pb.c          |    6 +
 arch/arm/mm/init.c                              |   11 ++
 21 files changed, 422 insertions(+), 50 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap4-panda.dts
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi
 create mode 100644 arch/arm/boot/dts/tegra-harmony.dts
 create mode 100644 arch/arm/boot/dts/versatile-ab.dts
 create mode 100644 arch/arm/boot/dts/versatile-pb.dts
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

-- 
Signature
