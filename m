Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HYXn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:43:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43194 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1HYXnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:43:55 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Thu, 25 Aug 2011 17:43:31 -0600
Message-Id: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
* Build on Jamie Iles' patches to split some of the DT parsing into
  common code.
* Renamed some properties to remove "nvidia," from name; they can be
  generic.
* Support pins property, to apply DT nodes to multiple pins/groups
* Some minor error-message changes driven by some of the above.
* Removed requirement to #ifdef CONFIG_OF
* Removed AUXDATA table entries in mach-tegra/board-dt.c

TODO:
* Convert from using strings to using integers for the function and pin
  names. This relies on the dtc patches I posted yesterday, but should
  be pretty simple once they're in.

Jamie Iles (1):
  of: add a generic pinmux helper

Stephen Warren (12):
  arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
  docs/dt: Document nvidia,tegra20-gpio's nvidia,enabled-gpios property
  arm/dt: Tegra: Add nvidia,enabled-gpios property to GPIO controller
  docs/dt: Document nvidia,tegra20-pinmux binding
  arm/dt: Tegra: Add pinmux node
  dt: add empty for_each_child_of_node, of_find_property
  gpio/tegra: Convert to a platform device
  gpio/tegra: Add device tree support
  arm/tegra: Convert pinmux driver to a platform device
  of: add property iteration helpers
  arm/tegra: Add device tree support to pinmux driver
  arm/tegra: board-dt: Remove dependency on non-dt pinmux functions

 .../devicetree/bindings/gpio/gpio_nvidia.txt       |   20 ++
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  302 ++++++++++++++++++++
 arch/arm/boot/dts/tegra-harmony.dts                |  258 +++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |  247 ++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi                     |    5 +
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/board-dt.c                     |   10 -
 arch/arm/mach-tegra/board-harmony-pinmux.c         |    8 +
 arch/arm/mach-tegra/board-paz00-pinmux.c           |    8 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |    9 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +
 arch/arm/mach-tegra/devices.c                      |   10 +
 arch/arm/mach-tegra/devices.h                      |    2 +
 arch/arm/mach-tegra/pinmux.c                       |  280 ++++++++++++++++++
 drivers/gpio/gpio-tegra.c                          |   48 +++-
 drivers/of/Kconfig                                 |    5 +
 drivers/of/Makefile                                |    1 +
 drivers/of/of_pinmux.c                             |  109 +++++++
 include/linux/of.h                                 |   10 +
 include/linux/of_iter_prop.h                       |  135 +++++++++
 include/linux/of_pinmux.h                          |   74 +++++
 21 files changed, 1524 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
 create mode 100644 drivers/of/of_pinmux.c
 create mode 100644 include/linux/of_iter_prop.h
 create mode 100644 include/linux/of_pinmux.h

