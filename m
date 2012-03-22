Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2CVRVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:21:02 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55781 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2CVRVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:21:00 -0400
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL] pinctrl changes for 3.4
Date: Thu, 22 Mar 2012 18:20:51 +0100
Message-Id: <1332436851-31570-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

These are the queued pinctrl developments for the 3.4 merge window.
As you can see Stephen Warren has stepped in and done a significant
chunk of development.

Main features:

- - Switches the PXA 168, 910 and MMP over to use pinctrl
- - Locking is much revamped
- - Massive refactorings...
- - Reform the driver API to use multiple states
- - Support pin config in the mapping tables
- - Pinctrl drivers for the nVidia Tegra series
- - Generic pin config support lib for simple pin controllers
- - Implement pin config for the U300

Please pull them! I've tried to use a signed tag, hopefully it worked.

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git tags/pinctrl-for-3.4

Haojian Zhuang (1):
      pinctrl: enable pinmux for mmp series

Linus Walleij (18):
      pinctrl: restore pin naming
      pinctrl: delete raw device pointers in pinmux maps
      pinctrl: break out a pinctrl consumer header
      pinctrl: move generic functions to the pinctrl_ namespace
      pinctrl: factor pin control handles over to the core
      pinctrl: changes hog mechanism to be self-referential
      serial/sirf: fixup for changes to pin control
      pinctrl: spawn U300 pinctrl from the COH901 GPIO
      pinctrl: make the pinmux-pins more helpful
      pinctrl: fix the pin descriptor kerneldoc
      pinctrl: include machine header to core.h
      pinctrl: split pincontrol states into its own header
      Merge branch 'pinctrl-tegra-for-next-diet' into for-next
      pinctrl: fix error path in pinconf_map_to_setting()
      pinctrl: introduce generic pin config
      pinctrl/coh901: use generic pinconf enums and parameters
      pinctrl: support pinconfig on the U300
      ARM: u300: configure some pins as an example

Stephen Warren (31):
      pinctrl: make "hog" mapping table entries work
      pinctrl: pinctrl_register_mappings() shouldn't be __init
      pinctrl: use list_add_tail instead of list_add
      pinctrl: Store mapping table as a list of chunks
      pinctrl: Re-order pinmux.[ch] to match each-other
      pinctrl: Re-order pinconf.[ch] to match each-other
      pinctrl: core.c/h cleanups
      pinctrl: assume map table entries can't have a NULL ctrl_dev_name field
      pinctrl: downgrade pinctrl_get warning when no maps are found
      pinctrl: error if mapping table's control dev can't be found
      pinctrl: record a pin owner, not mux function, when requesting pins
      pinctrl: fix pinconf_groups_show() to emit newline
      pinctrl: disallow map table entries with NULL dev_name field
      pinctrl: use dev_*() instead of pr_*(), add some msgs, minor cleanups
      pinctrl: allocate sizeof(*p) instead of sizeof(struct foo)
      pinctrl: remove pin and hogs locks from struct pinctrl_dev
      pinctrl: re-order struct pinctrl_map
      pinctrl: move pinctrl-maps debugfs file to top-level
      pinctrl: enhance pinctrl_get() to handle multiple functions
      pinctrl: introduce PINCTRL_STATE_DEFAULT, define hogs as that state
      pinctrl: assume map table entries can't have a NULL name field
      pinctrl: fix and simplify locking
      pinctrl: refactor struct pinctrl handling in core.c vs pinmux.c
      pinctrl: add usecount to pins for muxing
      pinctrl: API changes to support multiple states per device
      pinctrl: enhance mapping table to support pin config operations
      pinctrl: Show selected function and group in pinmux-pins debugfs
      pinctrl: add a driver for NVIDIA Tegra
      ARM: tegra: Select PINCTRL Kconfig variables
      pinctrl: forward-declare struct device
      pinctrl: allow concurrent gpio and mux function ownership of pins

 Documentation/pinctrl.txt                        |  311 ++-
 arch/arm/mach-tegra/Kconfig                      |    4 +
 arch/arm/mach-tegra/include/mach/pinconf-tegra.h |   63 +
 arch/arm/mach-u300/core.c                        |   80 +-
 arch/arm/mach-u300/include/mach/gpio-u300.h      |    2 +
 drivers/pinctrl/Kconfig                          |   42 +
 drivers/pinctrl/Makefile                         |    8 +
 drivers/pinctrl/core.c                           |  828 +++++-
 drivers/pinctrl/core.h                           |  117 +-
 drivers/pinctrl/pinconf-generic.c                |  120 +
 drivers/pinctrl/pinconf.c                        |  306 ++-
 drivers/pinctrl/pinconf.h                        |   78 +-
 drivers/pinctrl/pinctrl-coh901.c                 |  139 +-
 drivers/pinctrl/pinctrl-coh901.h                 |    5 +
 drivers/pinctrl/pinctrl-mmp2.c                   |  722 +++++
 drivers/pinctrl/pinctrl-pxa168.c                 |  651 ++++
 drivers/pinctrl/pinctrl-pxa3xx.c                 |  244 ++
 drivers/pinctrl/pinctrl-pxa3xx.h                 |  264 ++
 drivers/pinctrl/pinctrl-pxa910.c                 | 1007 ++++++
 drivers/pinctrl/pinctrl-tegra.c                  |  559 ++++
 drivers/pinctrl/pinctrl-tegra.h                  |  163 +
 drivers/pinctrl/pinctrl-tegra20.c                | 2860 +++++++++++++++++
 drivers/pinctrl/pinctrl-tegra30.c                | 3726 ++++++++++++++++++++++
 drivers/pinctrl/pinctrl-u300.c                   |   80 +-
 drivers/pinctrl/pinmux.c                         | 1205 ++------
 drivers/pinctrl/pinmux.h                         |   76 +-
 drivers/tty/serial/sirfsoc_uart.c                |   24 +-
 drivers/tty/serial/sirfsoc_uart.h                |    2 +-
 include/linux/pinctrl/consumer.h                 |  159 +
 include/linux/pinctrl/machine.h                  |  190 +-
 include/linux/pinctrl/pinconf-generic.h          |  114 +
 include/linux/pinctrl/pinconf.h                  |   44 +-
 include/linux/pinctrl/pinctrl-state.h            |    6 +
 include/linux/pinctrl/pinctrl.h                  |    3 +-
 include/linux/pinctrl/pinmux.h                   |   52 -
 35 files changed, 12806 insertions(+), 1448 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/pinconf-tegra.h
 create mode 100644 drivers/pinctrl/pinconf-generic.c
 create mode 100644 drivers/pinctrl/pinctrl-coh901.h
 create mode 100644 drivers/pinctrl/pinctrl-mmp2.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa168.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa3xx.c
 create mode 100644 drivers/pinctrl/pinctrl-pxa3xx.h
 create mode 100644 drivers/pinctrl/pinctrl-pxa910.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra20.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra30.c
 create mode 100644 include/linux/pinctrl/consumer.h
 create mode 100644 include/linux/pinctrl/pinconf-generic.h
 create mode 100644 include/linux/pinctrl/pinctrl-state.h
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPa1zwAAoJEEEQszewGV1zDvIP/2yXNWRtX/+f74W5DOwvsPef
g8P1dYblf5uV+Vny/6oYd9w71Gg0Nukr+cLNRLG9ieY/VxAsQ8URQDownZG1FGaA
ePKvIQR79/lXfuYqugywuxI9bsAwcC8MWYFGOYQoVaOxOGZy1vFnvZFHKZZVje8p
19oZrQ5mAtZfQStNtPskEUef/18cCq4n/z+RXBwZotJeFu6Ah+Z8ymhKFgcBxUjx
At4Onb3WdcbJEjIHftLqzSOlkblZZIasfafVWXNy9lBkV2kApNYoc5SQBr0qBvRE
9MnP3eK3p0Rw81OxOBqwNxBDf+uBvR8DCYF3Y83rJCPnce/dVwzzqrzMPZZP6T1k
S5hVSvK/FtEU5qzIWQIRZbSh5aNcZJ2Ca2VG8pIpkhFB98eT/DO7zCmF+oFSB7Cf
TOoD+bPxjdb9fEI9Byd/YXQzDdii3S6ZtvEdK9IvXef6CwEaCj9KP2hnB8XYbk31
VPJJkFnA1HJn1uScoY9cxiacyS20+KRwMvz7UyjUz/y4FBHxrmUc8oDasRtZerxV
vEP6BcURiotBGOpJepu8GAcMiKodxVIOcCfC25KmMHcqfgXjFdi43q+E7ckMLksB
MWYqHPfXWaun3kqIR6BqlQ9fFQK/lsUlXGvS2Qi391WzmyIt1J2a9LDjKaKfhquZ
bw6DDhE8igb6H6I5/fM2
=O/f9
-----END PGP SIGNATURE-----
