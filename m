Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2HFMXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:23:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2HFMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:23:51 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 0/6] ARM: dove: DT support for Marvell Dove
Date: Mon,  6 Aug 2012 14:23:28 +0200
Message-Id: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds DT support for Marvell Dove SoC and three boards
equipped with this SoC. The work is based on device tree support for
Marvell Orion based SoCs introduced in 3.6-rc1.

The first three patches move mach-dove closer to Marvell Kirkwood's
setup code by unifying the clock setup routines, adding clock gating
control, and support for Marvell's crypto engine to mach-dove.

Patches 4 and 5 add a generic DT machine descriptor to mach-dove and
corresponding DT descriptors for the SoC and already supported boards.

Finally, the last patch adds a DT descriptor for the SolidRun CuBox,
a plug computer based on Marvell Dove.

This patch set relies on a DT support patch for sdhci-dove that has
been sent to the corresponding maintainers a few days ago.

Sebastian Hesselbarth (6):
  ARM: dove: unify clock setup
  ARM: dove: add clock gating control
  ARM: dove: add crypto engine
  ARM: dove: add device tree based machine descriptor
  ARM: dove: add device tree descriptors
  ARM: dove: SolidRun CuBox DT

 arch/arm/boot/dts/dove-cm-a510.dts   |   38 ++++++++
 arch/arm/boot/dts/dove-cubox.dts     |   42 +++++++++
 arch/arm/boot/dts/dove-dove-db.dts   |   38 ++++++++
 arch/arm/boot/dts/dove.dtsi          |  143 ++++++++++++++++++++++++++++++
 arch/arm/mach-dove/Kconfig           |    7 ++
 arch/arm/mach-dove/Makefile.boot     |    4 +
 arch/arm/mach-dove/common.c          |  159 +++++++++++++++++++++++++++++++---
 arch/arm/mach-dove/include/mach/pm.h |   54 ++++++++----
 8 files changed, 455 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm/boot/dts/dove-cm-a510.dts
 create mode 100644 arch/arm/boot/dts/dove-cubox.dts
 create mode 100644 arch/arm/boot/dts/dove-dove-db.dts
 create mode 100644 arch/arm/boot/dts/dove.dtsi

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
-- 
1.7.10.4

