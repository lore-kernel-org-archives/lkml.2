Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2HTCux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:50:53 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55596 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab2HTCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:50:51 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com,
        arnd@arndb.de
Subject: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
Date: Mon, 20 Aug 2012 10:55:10 +0800
Message-Id: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 20 Aug 2012 02:50:32.0837 (UTC) FILETIME=[91108350:01CD7E7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

v1->v2:
replace __raw_xxx with xxx_relax
use ioremap to remap the registers. Finaly it will use device tree to
get the physical address.
do not use macro to register clocks, and directly call the functions.

v2->v3:
pxa910 will have APB extension clock, so some peripharals will have
clocks in APB extension base.
change pxa168-pwm to be pxa910-pwm for pxa910. It will fit the current
pwm driver.

v3->v4:
remove addtional clock name definition
replace left __raw_xxx

v4->v5:
change the format of the file

Chao Xie (5):
  clk: mmp: add mmp specific clocks
  clk: mmp: add clock definition for pxa168
  clk: mmp: add clock definition for pxa910
  clk: mmp: add clock definition for mmp2
  arm: mmp: make all SOCs use common clock by default

 arch/arm/mach-mmp/Kconfig    |    3 +
 drivers/clk/Makefile         |    3 +
 drivers/clk/mmp/Makefile     |    9 +
 drivers/clk/mmp/clk-apbc.c   |  152 ++++++++++++++
 drivers/clk/mmp/clk-apmu.c   |   97 +++++++++
 drivers/clk/mmp/clk-frac.c   |  153 ++++++++++++++
 drivers/clk/mmp/clk-mmp2.c   |  449 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-pxa168.c |  346 ++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk-pxa910.c |  320 ++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h        |   35 ++++
 10 files changed, 1567 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/mmp/Makefile
 create mode 100644 drivers/clk/mmp/clk-apbc.c
 create mode 100644 drivers/clk/mmp/clk-apmu.c
 create mode 100644 drivers/clk/mmp/clk-frac.c
 create mode 100644 drivers/clk/mmp/clk-mmp2.c
 create mode 100644 drivers/clk/mmp/clk-pxa168.c
 create mode 100644 drivers/clk/mmp/clk-pxa910.c
 create mode 100644 drivers/clk/mmp/clk.h

