Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031448Ab2HIPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:54:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38732 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031300Ab2HIPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:54:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/8] Changes surrounding IRQs and IRQ domains 
Date: Thu,  9 Aug 2012 16:53:47 +0100
Message-Id: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we apply some fixes to the way the AB8500 handles IRQs and
provide the DB8500 with an IRQ domain. We also handle hwirq to
virq conversion slightly differently when registering MFD devices.
The other changes pertain to the way IRQs are requested and dealt
with by AB8500 child devices.

 arch/arm/boot/dts/dbx5x0.dtsi      |    3 ++
 drivers/input/misc/ab8500-ponkey.c |    4 +--
 drivers/mfd/ab8500-core.c          |    3 +-
 drivers/mfd/db8500-prcmu.c         |   54 +++++++++++++++++++++++++++---------
 drivers/mfd/mfd-core.c             |    2 +-
 include/linux/mfd/db8500-prcmu.h   |    2 ++
 include/linux/of_irq.h             |    5 ++++
 kernel/irq/irqdomain.c             |    7 +++++
 8 files changed, 63 insertions(+), 17 deletions(-)

