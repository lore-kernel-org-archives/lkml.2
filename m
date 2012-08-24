Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2HXJSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:18:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2HXJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:18:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de
Subject: [PATCH 0/5] Add device tree support for on-chip SRAM
Date: Fri, 24 Aug 2012 11:17:41 +0200
Message-Id: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to configure the on-chip SRAM via device-tree
node and to obtain the resulting genalloc pool from a phandle pointing   
at the node.
This allows drivers to allocate SRAM with the genalloc API without
hard-coding the genalloc pool address.

regards
Philipp

---
 arch/arm/boot/dts/imx53.dtsi          |    5 ++
 arch/arm/boot/dts/imx6q.dtsi          |    5 ++
 arch/arm/plat-mxc/include/mach/iram.h |   41 -----------------
 arch/arm/plat-mxc/iram_alloc.c        |   81 ++++++++++++++++++++-------------
 include/linux/genalloc.h              |   14 ++++++
 lib/genalloc.c                        |   77 +++++++++++++++++++++++++++++++
 6 files changed, 150 insertions(+), 73 deletions(-)

