Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab2JCQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:31:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43070 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab2JCQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:31:47 -0400
Message-ID: <506C686E.1050609@gmail.com>
Date: Wed, 03 Oct 2012 11:31:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: [GIT PULL] Devicetree updates for 3.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull Devicetree updates for 3.7. I'm filling in for Grant again
this cycle.

The biggest change here is the import of the current upstream dtc
scripts. Other than that, it's the typical small set of changes.

There's one conflict with commit 3296193d1421c2d6f9 (dt: introduce
for_each_available_child_of_node, of_get_next_available_child), but it
is just context differences.

Rob

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/dt-for-3.7

for you to fetch changes up to 36165f55055781a0e4bf32d775241796414504b0:

  MAINTAINERS: add scripts/dtc under Devicetree maintainers (2012-10-01
20:09:23 -0500)

----------------------------------------------------------------
Devicetree updates for 3.7

- Import of latest upstream device tree compiler (dtc)
- New function of_get_child_by_name
- Support for #size-cells of 0 and #addr-cells of >2
- Couple of DT binding documentation updates

----------------------------------------------------------------
Fabio Estevam (2):
      devicetree: pwm: mxs-pwm.txt: Fix reg field annotation
      devicetree: serial: Add documentation for imx serial

John Crispin (1):
      DT: export of_irq_to_resource_table()

Olof Johansson (1):
      of: i2c: add support for wakeup-source property

Rob Herring (1):
      MAINTAINERS: add scripts/dtc under Devicetree maintainers

Srinivas Kandagatla (2):
      dt: introduce of_get_child_by_name to get child node by name
      dt/s3c64xx/spi: Use of_get_child_by_name to get a named child

Stephen Warren (2):
      of: Allow busses with #size-cells=0
      dtc: import latest upstream dtc

Thierry Reding (2):
      of/address: Handle #address-cells > 2 specially
      dt: Document general interrupt controller bindings

 .../bindings/interrupt-controller/interrupts.txt   |   95 +++
 Documentation/devicetree/bindings/pwm/mxs-pwm.txt  |    2 +-
 .../devicetree/bindings/serial/fsl-imx-uart.txt    |   35 +
 MAINTAINERS                                        |    1 +
 drivers/of/address.c                               |   35 +-
 drivers/of/base.c                                  |   23 +
 drivers/of/irq.c                                   |    1 +
 drivers/of/of_i2c.c                                |    3 +
 drivers/of/platform.c                              |   16 +-
 drivers/spi/spi-s3c64xx.c                          |    7 +-
 include/linux/of.h                                 |    2 +
 include/linux/of_address.h                         |    1 +
 scripts/dtc/Makefile.dtc                           |   13 +-
 scripts/dtc/checks.c                               |  203 +++--
 scripts/dtc/data.c                                 |  124 +---
 scripts/dtc/dtc-lexer.l                            |   65 +-
 scripts/dtc/dtc-lexer.lex.c_shipped                |  503 +++++++++----
 scripts/dtc/dtc-parser.tab.c_shipped               |  780
++++++++++++++++----
 scripts/dtc/dtc-parser.tab.h_shipped               |   47 +-
 scripts/dtc/dtc-parser.y                           |  255 ++++++-
 scripts/dtc/dtc.c                                  |   21 +-
 scripts/dtc/dtc.h                                  |   51 +-
 scripts/dtc/fdtdump.c                              |  162 ++++
 scripts/dtc/fdtget.c                               |  366 +++++++++
 scripts/dtc/fdtput.c                               |  362 +++++++++
 scripts/dtc/flattree.c                             |    3 +
 scripts/dtc/libfdt/Makefile.libfdt                 |    6 +-
 scripts/dtc/libfdt/fdt.c                           |   61 +-
 scripts/dtc/libfdt/fdt_empty_tree.c                |   84 +++
 scripts/dtc/libfdt/fdt_ro.c                        |  275 ++++---
 scripts/dtc/libfdt/fdt_rw.c                        |   29 +
 scripts/dtc/libfdt/fdt_sw.c                        |   11 +-
 scripts/dtc/libfdt/fdt_wip.c                       |   41 +-
 scripts/dtc/libfdt/libfdt.h                        |  440 ++++++++++-
 scripts/dtc/libfdt/libfdt_env.h                    |   16 +-
 scripts/dtc/libfdt/libfdt_internal.h               |    2 +-
 scripts/dtc/livetree.c                             |  128 +++-
 scripts/dtc/srcpos.c                               |   98 ++-
 scripts/dtc/srcpos.h                               |   31 +
 scripts/dtc/treesource.c                           |    2 +
 scripts/dtc/util.c                                 |  272 +++++++
 scripts/dtc/util.h                                 |   97 +++
 42 files changed, 4057 insertions(+), 712 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
 create mode 100644
Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
 create mode 100644 scripts/dtc/fdtdump.c
 create mode 100644 scripts/dtc/fdtget.c
 create mode 100644 scripts/dtc/fdtput.c
 create mode 100644 scripts/dtc/libfdt/fdt_empty_tree.c
