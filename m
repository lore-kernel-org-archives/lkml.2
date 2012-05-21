Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2EULtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:49:07 -0400
Received: from mail.df.lth.se ([194.47.250.12]:27352 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab2EULtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:49:05 -0400
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: =?UTF-8?q?=5BGIT=20PULL=5D=20pin=20control=20changes=20for=20v3=2E5?=
Date: Mon, 21 May 2012 13:48:32 +0200
Message-Id: <1337600912-6077-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

these are the accumulated pin control patches for the v3.5 merge window.

Highlights:
- - Generic Device Tree bindings and hooks for drivers so we can
  move modern drivers to using this.
- - Device Tree bindings for Tegra SoCs.
- - Funneling some devicetree helper code for the drivers/of
 subsystem.
- - New pin control drivers for:
 - Freescale MXS
 - Freescale i.MX51
 - Freescale i.MX53
 - All of these use Device Tree bindings.
- - Dummy pinctrl handles for stepwise migration to pinctrl, akin
 to dummy regulators.
- - Minor non-urgent fixes and improvments.

This is not all: additional pin control migrations will come in from
the ARM SoC tree as SPEAr and ux500 migrate, and I think we have a
MIPS driver coming from a platform tree as well.

As you can see I have pushed a signed tag base on v3.4-rc3.
Please pull it in, thanks.

Linus Walleij


The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git pinctrl-for-v3.5

Dong Aisheng (18):
      pinctrl: fix compile error if not select PINMUX support
      pinctrl: fix pinmux_check_ops error checking
      pinctrl: add some error checking for user interfaces
      pinctrl: a minor fix of pin config debug information
      pinctrl: show pin name when request pins
      pinctrl: show pin name for pingroups in sysfs
      pinctrl: add pinctrl_provide_dummies interface for platforms to use
      pinctrl: support gpio request deferred probing
      dt: add of_get_child_count helper function
      pinctrl: pinctrl-imx: add imx pinctrl core driver
      pinctrl: pinctrl-imx: add imx6q pinctrl driver
      pinctrl: a minor error checking improvement for pinconf
      pinctrl: make pinmux disable function optional
      pinctrl: pinctrl-imx: remove empty pinmux disable function
      pinctrl: pinctrl-mxs: remove empty pinmux disable function
      pinctrl: pinctrl-pxa3xx: remove empty pinmux disable function
      pinctrl: pinctrl-imx: add imx53 pinctrl driver
      pinctrl: pinctrl-imx: add imx51 pinctrl driver

Guennadi Liakhovetski (1):
      pinctrl: (cosmetic) fix two entries in DocBook comments

John Crispin (2):
      pinctrl: fix signed vs unsigned conditionals inside pinmux_map_to_setting
      pinctrl: enhance reporting of errors when loading from DT

Linus Walleij (3):
      pinctrl: implement pinctrl deferred probing
      pinctrl: mark non-EXPERIMENTAL
      pinctrl: fix dangling comment

Shawn Guo (3):
      pinctrl: add pinctrl-mxs support
      pinctrl: mxs: create group for pin config node
      pinctrl: mxs: skip gpio nodes for group creation

Stephen Warren (15):
      pinctrl: include <linux/bug.h> to prevent compile errors
      pinctrl: implement pinctrl_check_ops
      pinctrl: core device tree mapping table parsing support
      pinctrl: fix build when CONFIG_OF && !CONFIG_PINCTRL
      dt: add property iteration helpers
      dt: pinctrl: Document device tree binding
      dt: Move Tegra20 pin mux binding into new pinctrl directory
      dt: Document Tegra20/30 pinctrl binding
      pinctrl: tegra: Add complete device tree support
      pinctrl: ifdef CONFIG_DEBUG_FS cleanup
      pinctrl: allow pctldevs to decode pin config in debugfs
      pinctrl: implement devm_pinctrl_get()/put()
      pinctrl: propagate map validation errors
      pinctrl: add kerneldoc for pinctrl_ops device tree functions
      pinctrl: add more info to error msgs in pin_request

Uwe Kleine-König (1):
      pinctrl: mark const init data with __initconst instead of __initdata

Viresh Kumar (3):
      Documentation: pinctrl: add missing spi0_0 grp in example
      pinctrl: replace list_*() with get_*_count()
      pinctrl: pinconf: fix compilation error if PINCONF is not selected

 .../bindings/pinctrl/fsl,imx-pinctrl.txt           |   95 +
 .../bindings/pinctrl/fsl,imx51-pinctrl.txt         |  787 +++++++
 .../bindings/pinctrl/fsl,imx53-pinctrl.txt         | 1202 ++++++++++
 .../bindings/pinctrl/fsl,imx6q-pinctrl.txt         | 1628 ++++++++++++++
 .../bindings/pinctrl/fsl,mxs-pinctrl.txt           |  918 ++++++++
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |  132 ++
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |  132 ++
 .../bindings/pinctrl/pinctrl-bindings.txt          |  128 ++
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |    5 -
 Documentation/driver-model/devres.txt              |    4 +
 Documentation/pinctrl.txt                          |   94 +-
 drivers/of/base.c                                  |   41 +
 drivers/pinctrl/Kconfig                            |   45 +-
 drivers/pinctrl/Makefile                           |   10 +
 drivers/pinctrl/core.c                             |  263 ++-
 drivers/pinctrl/core.h                             |   12 +-
 drivers/pinctrl/devicetree.c                       |  249 +++
 drivers/pinctrl/devicetree.h                       |   35 +
 drivers/pinctrl/pinconf.c                          |   56 +-
 drivers/pinctrl/pinconf.h                          |   17 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    4 +-
 drivers/pinctrl/pinctrl-imx.c                      |  620 ++++++
 drivers/pinctrl/pinctrl-imx.h                      |  106 +
 drivers/pinctrl/pinctrl-imx23.c                    |  305 +++
 drivers/pinctrl/pinctrl-imx28.c                    |  421 ++++
 drivers/pinctrl/pinctrl-imx51.c                    | 1322 +++++++++++
 drivers/pinctrl/pinctrl-imx53.c                    | 1649 ++++++++++++++
 drivers/pinctrl/pinctrl-imx6q.c                    | 2331 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-mxs.c                      |  528 +++++
 drivers/pinctrl/pinctrl-mxs.h                      |   91 +
 drivers/pinctrl/pinctrl-pxa3xx.c                   |   30 +-
 drivers/pinctrl/pinctrl-sirf.c                     |   20 +-
 drivers/pinctrl/pinctrl-tegra.c                    |  245 ++-
 drivers/pinctrl/pinctrl-u300.c                     |   20 +-
 drivers/pinctrl/pinmux.c                           |   97 +-
 drivers/pinctrl/pinmux.h                           |   18 +-
 include/linux/of.h                                 |   51 +
 include/linux/pinctrl/consumer.h                   |   44 +
 include/linux/pinctrl/machine.h                    |   11 +-
 include/linux/pinctrl/pinconf.h                    |    6 +-
 include/linux/pinctrl/pinctrl.h                    |   22 +-
 include/linux/pinctrl/pinmux.h                     |    9 +-
 42 files changed, 13555 insertions(+), 248 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx51-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx53-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
 delete mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
 create mode 100644 drivers/pinctrl/devicetree.c
 create mode 100644 drivers/pinctrl/devicetree.h
 create mode 100644 drivers/pinctrl/pinctrl-imx.c
 create mode 100644 drivers/pinctrl/pinctrl-imx.h
 create mode 100644 drivers/pinctrl/pinctrl-imx23.c
 create mode 100644 drivers/pinctrl/pinctrl-imx28.c
 create mode 100644 drivers/pinctrl/pinctrl-imx51.c
 create mode 100644 drivers/pinctrl/pinctrl-imx53.c
 create mode 100644 drivers/pinctrl/pinctrl-imx6q.c
 create mode 100644 drivers/pinctrl/pinctrl-mxs.c
 create mode 100644 drivers/pinctrl/pinctrl-mxs.h
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuiiUAAoJEEEQszewGV1zGVAP/iKIJX3LcPW1GRIBUZ6eE/EF
OeqeQmf0WXFtGg4Saun4HzmUy/X35VHbKKzELW2WncUsF24Wc7DSf9F9zU6Jfr40
YI/FcK0oFlaKjhqZW6TpO9A1I/TbRYjmgETwxHt+/xO8YLfdP2Y5erUHJ2yDHfK4
LZmOYtPSqQcfvAEg82o/9QpGhZquVzMjt7SZkiJUis/7JGY30lmiVMh36gtD74pB
eLCQeJwVWPga5ban96v/KGibf+ZkbVViufGMUIt6ZVjvej2hNWnAF5jgp/h4Oi/f
U6YbgBZk8CKJVKLuRzu+/qhBY5yZoZ8j5y24m9/pK1O0/FPFgSNz/XqfflfUd/py
UJ7eHgnHZjigktG99TQuOATa22joULFMbYBrQjGjDvnIA9X7H69g1Gc2VW8iAts0
gF+64zuoKwURumueo1r6TKxA4PI/IZzeYV9AaKVdtbN4DQAudS4XVFizRKdqagjX
/AfKJs4iHMlmGm2xgPGZrwdrpdqvzpqPlMUyEp2O0LJPye41iVRMD6eWsIUhGxI0
dnPK+gw8ylnV2/SlRUpX8NUKhPgeam9VeQhJxh2Tkou69hUiqa70XKK1CXwee24l
DP9ZxQXrKHTEnOHNjFAjrg0Bf1/j/UrMSoA8TiHeEG+DWnYY1ywiy+M2UwZRmfZT
ycvsMxvi8QyAy4FlbACL
=uuUU
-----END PGP SIGNATURE-----
