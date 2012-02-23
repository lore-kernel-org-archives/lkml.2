Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2BWORy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:17:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43814 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2BWORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:17:53 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <sameo@linux.intel.com>, "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v5 0/3]Move davinci emif driver to MFD from platform code
Date: Thu, 23 Feb 2012 19:28:21 +0530
Message-ID: <1330005504-25321-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch series are based on the discussion and concerns expressed in
davinci-linux-open-source community. Here is the link to the thread:
http://davinci-linux-open-source.1494791.n2.nabble.com/PATCH-arm-davinci-configure-davinci-aemif-chipselects-through-OF-tt7059739.html#none

Manjunathappa, Prakash (3):
  arm:davinci: prepare to move aemif driver to drivers/mfd
  arm:davinci: move emif driver to mfd framework
  arm:davinci: move NAND and NOR devices as emif MFD slaves

 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/aemif.c                      |  133 -------------
 arch/arm/mach-davinci/board-da830-evm.c            |   33 +++-
 arch/arm/mach-davinci/board-da850-evm.c            |   56 +++---
 arch/arm/mach-davinci/board-dm355-evm.c            |   33 +++-
 arch/arm/mach-davinci/board-dm355-leopard.c        |   35 +++-
 arch/arm/mach-davinci/board-dm365-evm.c            |   34 +++-
 arch/arm/mach-davinci/board-dm644x-evm.c           |  175 ++++++++++-------
 arch/arm/mach-davinci/board-dm646x-evm.c           |   32 +++-
 arch/arm/mach-davinci/board-mityomapl138.c         |   34 +++-
 arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
 arch/arm/mach-davinci/board-sffsdr.c               |   34 +++-
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/davinci_aemif.c                        |  206 ++++++++++++++++++++
 drivers/mtd/nand/davinci_nand.c                    |    2 +-
 .../aemif.h => include/linux/mfd/davinci_aemif.h   |   14 ++
 17 files changed, 527 insertions(+), 299 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/aemif.c
 create mode 100644 drivers/mfd/davinci_aemif.c
 rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/mfd/davinci_aemif.h (74%)

