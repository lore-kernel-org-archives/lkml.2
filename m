Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2KUJkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:40:49 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:36943 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2KUJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:40:01 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
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
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/3] Add hardware I/O coherency support for Armada 370/XP
Date: Wed, 21 Nov 2012 10:39:39 +0100
Message-Id: <1353490783-23101-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch set is to add hardware I/O Coherency support
for Armada 370 and Armada XP. Theses SoCs come with an unit called
coherency fabric. A beginning of the support for this unit have been
introduced with the SMP patch set. This series extend this support:
the coherency fabric unit allows to use the Armada XP and the Armada
370 as nearly coherent architectures.

The third patches enables this new feature and register our own set
of DMA ops, to benefit this hardware enhancement.

The first patches exports dma operation functions needed by to
register our own set of dma ops.

The second patch introduces a new flag for the address decoding
configuration in order to be able to set the memory windows as
shared memory.

This series depend on the SMP patch set (V5 was posted few minutes
earlier)

The git branch called HWIOCC-for-3.8-V3 is also available at
https://github.com/MISL-EBU-System-SW/mainline-public.git.

Changelog:
V3->V4:
- Exposed only the needed dma ops function

V2 -> V3:
- Rebased on to ArmadaXP-SMP-for-3.8-V5
- Use the coherent version of dma ops for .alloc() and .free()

V1 -> V2:
- Rebased on to v3.7-rc5
- Added a new patch to exports the dma ops functions
- Renamed the function for a more generic name mvebu_hwcc
- removed the non SMP case during init
- spelling and wording issues
- updating the binding documentation for coherency fabric

Gregory CLEMENT (3):
  arm: dma mapping: Export a dma ops function arm_dma_set_mask
  arm: plat-orion: Add coherency attribute when setup mbus target
  arm: mvebu: Add hardware I/O Coherency support

 .../devicetree/bindings/arm/coherency-fabric.txt   |    9 ++-
 arch/arm/boot/dts/armada-370-xp.dtsi               |    3 +-
 arch/arm/include/asm/dma-mapping.h                 |    2 +
 arch/arm/mach-mvebu/addr-map.c                     |    3 +
 arch/arm/mach-mvebu/coherency.c                    |   73 ++++++++++++++++++++
 arch/arm/mm/dma-mapping.c                          |    4 +-
 arch/arm/plat-orion/addr-map.c                     |    4 ++
 arch/arm/plat-orion/include/plat/addr-map.h        |    1 +
 8 files changed, 93 insertions(+), 6 deletions(-)

-- 
1.7.9.5

