Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2LRNLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:11:49 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35877 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708Ab2LRNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:11:48 -0500
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 0/9] drivers: mailbox: framework creation
Date: Tue, 18 Dec 2012 14:10:03 +0100
Message-ID: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP and ST-Ericsson platforms are both using mailbox to communicate
with some coprocessors.
Based on OMAP existing mailbox framework, this series proposes a
generic framework, living under drivers/mailbox.

This series:
- moves omap-mailbox framework to a newly drivers/mailbox folder
  (part of plat-omap code cleaning)
- creates API header file
- replaces "omap" prefix by "mailbox"
- opens interface and make framework independent from omap HW
- adapts existing omap1 and omap2 drivers to new changes
- creates dbx500 mailbox driver for ST-Ericsson platforms

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
Signed-off-by: Loic Pallardy <loic.pallardy@st.com>

Based on 3.7-rc7.

Loic Pallardy (9):
  mailbox: OMAP: introduce mailbox framework
  mailbox: split internal header from API header
  mailbox: rename omap_mbox in mailbox
  mailbox: create opened message type
  mailbox: change protection mechanisms
  mailbox: add shared memory mailbox type
  mailbox: add IRQF_NO_SUSPEND flag
  mailbox: add no_irq send message
  mailbox: create dbx500 mailbox driver

 arch/arm/configs/omap1_defconfig                   |   3 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap1/mailbox.c                      | 199 -------
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/devices.c                      |   4 +-
 arch/arm/plat-omap/Kconfig                         |  16 -
 arch/arm/plat-omap/Makefile                        |   3 -
 arch/arm/plat-omap/include/plat/mailbox.h          | 105 ----
 arch/arm/plat-omap/mailbox.c                       | 435 ---------------
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/mailbox/Kconfig                            |  51 ++
 drivers/mailbox/Makefile                           |   5 +
 drivers/mailbox/mailbox-dbx500.c                   | 601 +++++++++++++++++++++
 drivers/mailbox/mailbox-omap1.c                    | 222 ++++++++
 .../mailbox.c => drivers/mailbox/mailbox-omap2.c   | 230 ++++----
 drivers/mailbox/mailbox.c                          | 551 +++++++++++++++++++
 drivers/mailbox/mailbox.h                          |  66 +++
 include/linux/mailbox.h                            |  36 ++
 include/linux/platform_data/mailbox-dbx500.h       |  13 +
 20 files changed, 1672 insertions(+), 878 deletions(-)
 delete mode 100644 arch/arm/mach-omap1/mailbox.c
 delete mode 100644 arch/arm/plat-omap/include/plat/mailbox.h
 delete mode 100644 arch/arm/plat-omap/mailbox.c
 create mode 100644 drivers/mailbox/Kconfig
 create mode 100644 drivers/mailbox/Makefile
 create mode 100644 drivers/mailbox/mailbox-dbx500.c
 create mode 100644 drivers/mailbox/mailbox-omap1.c
 rename arch/arm/mach-omap2/mailbox.c => drivers/mailbox/mailbox-omap2.c (56%)
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 drivers/mailbox/mailbox.h
 create mode 100644 include/linux/mailbox.h
 create mode 100644 include/linux/platform_data/mailbox-dbx500.h

-- 
1.7.11.1

