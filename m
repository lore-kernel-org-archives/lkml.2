Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab2LWLHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:07:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13732 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2LWLHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:07:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 23 Dec 2012 03:07:28 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 00/11] Migrate Tegra to common clock framework
Date: Sun, 23 Dec 2012 16:35:40 +0530
Message-ID: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does following:
1. Decompose single tegra clock structure into multiple clocks.
2. Try to use standard clock types supported by common clock framework.
3. Use dynamic initialization.
4. Move all clock code to drivers/clk/tegra from mach-tegra.
5. Add device tree support for Tegra20 and Tegra30 clocks.
6. Remove all legacy clock code from mach-tegra.

Tested on Ventana (Tegra20) and Cardhu (Tegra30).

Prashant Gaikwad (10):
  clk: tegra: Add tegra specific clocks
  arm: tegra: Move tegra_cpu_car.h to linux/clk/tegra.h
  ARM: Tegra: Define Tegra30 CAR binding
  ARM: dt: tegra30: Add device node for APB MISC
  ARM: dt: tegra20: Add device node for APB MISC
  clk: tegra: add clock support for tegra20
  clk: tegra: add clock support for tegra30
  clk: tegra: add dt support
  arm: tegra: Migrate to new clock code
  arm: tegra: Remove legacy clock code

Stephen Warren (1):
  ARM: tegra: Define Tegra20 CAR binding

 .../bindings/clock/nvidia,tegra20-car.txt          |  209 ++
 .../bindings/clock/nvidia,tegra30-car.txt          |  282 +++
 arch/arm/boot/dts/tegra20.dtsi                     |   11 +
 arch/arm/boot/dts/tegra30.dtsi                     |   11 +
 arch/arm/mach-tegra/Makefile                       |    5 -
 arch/arm/mach-tegra/board-dt-tegra20.c             |   18 -
 arch/arm/mach-tegra/board-dt-tegra30.c             |   18 -
 arch/arm/mach-tegra/clock.c                        |  168 --
 arch/arm/mach-tegra/clock.h                        |  153 --
 arch/arm/mach-tegra/common.c                       |   39 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    5 +-
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/include/mach/clk.h             |   44 -
 arch/arm/mach-tegra/pcie.c                         |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    3 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +-
 arch/arm/mach-tegra/tegra20_clocks.c               | 1624 --------------
 arch/arm/mach-tegra/tegra20_clocks.h               |   42 -
 arch/arm/mach-tegra/tegra20_clocks_data.c          | 1140 ----------
 arch/arm/mach-tegra/tegra30_clocks.c               | 2293 --------------------
 arch/arm/mach-tegra/tegra30_clocks.h               |   53 -
 arch/arm/mach-tegra/tegra30_clocks_data.c          | 1378 ------------
 arch/arm/mach-tegra/timer.c                        |    1 -
 drivers/clk/Makefile                               |    1 +
 drivers/clk/tegra/Makefile                         |   11 +
 drivers/clk/tegra/clk-audio-sync.c                 |   89 +
 drivers/clk/tegra/clk-divider.c                    |  188 ++
 drivers/clk/tegra/clk-periph-gate.c                |  183 ++
 drivers/clk/tegra/clk-periph.c                     |  232 ++
 drivers/clk/tegra/clk-pll-out.c                    |  124 ++
 drivers/clk/tegra/clk-pll.c                        |  674 ++++++
 drivers/clk/tegra/clk-super.c                      |  154 ++
 drivers/clk/tegra/clk-tegra20.c                    | 1269 +++++++++++
 drivers/clk/tegra/clk-tegra30.c                    | 1961 +++++++++++++++++
 drivers/clk/tegra/clk.c                            |   97 +
 drivers/clk/tegra/clk.h                            |  493 +++++
 drivers/crypto/tegra-aes.c                         |    2 -
 drivers/dma/tegra20-apb-dma.c                      |    2 +-
 drivers/i2c/busses/i2c-tegra.c                     |    3 +-
 drivers/input/keyboard/tegra-kbc.c                 |    2 +-
 drivers/staging/nvec/nvec.c                        |    2 +-
 .../tegra_cpu_car.h => include/linux/clk/tegra.h   |   11 +-
 sound/soc/tegra/tegra30_ahub.c                     |    2 +-
 43 files changed, 6009 insertions(+), 6994 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
 delete mode 100644 arch/arm/mach-tegra/clock.c
 delete mode 100644 arch/arm/mach-tegra/clock.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/clk.h
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks.h
 delete mode 100644 arch/arm/mach-tegra/tegra20_clocks_data.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks.h
 delete mode 100644 arch/arm/mach-tegra/tegra30_clocks_data.c
 create mode 100644 drivers/clk/tegra/Makefile
 create mode 100644 drivers/clk/tegra/clk-audio-sync.c
 create mode 100644 drivers/clk/tegra/clk-divider.c
 create mode 100644 drivers/clk/tegra/clk-periph-gate.c
 create mode 100644 drivers/clk/tegra/clk-periph.c
 create mode 100644 drivers/clk/tegra/clk-pll-out.c
 create mode 100644 drivers/clk/tegra/clk-pll.c
 create mode 100644 drivers/clk/tegra/clk-super.c
 create mode 100644 drivers/clk/tegra/clk-tegra20.c
 create mode 100644 drivers/clk/tegra/clk-tegra30.c
 create mode 100644 drivers/clk/tegra/clk.c
 create mode 100644 drivers/clk/tegra/clk.h
 rename arch/arm/mach-tegra/tegra_cpu_car.h => include/linux/clk/tegra.h (89%)

-- 
1.7.4.1

