Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031433Ab2HIPyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:54:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59917 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031231Ab2HIPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:54:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/8] of/irq: Create stub for of_irq_find_parent when !CONFIG_OF
Date: Thu,  9 Aug 2012 16:53:48 +0100
Message-Id: <1344527635-6163-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_irq_find_parent is a handy function to use outside the confines of
the Open Firmware subsystem. One such use-case is when the IRQ Domain
wishes to find an IRQ domain for a given device node. Currently it can
not take any notice of the 'interrupt-parent' property. Instead it
just uses the first IRQ controller as it climbs the Device Tree. If
we were to use this as a precursor the resultant controller is more
likely to be correct.

CC: Rob Herring <rob.herring@calxeda.com>
CC: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/of_irq.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 1717cd9..b8e2411 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -83,6 +83,11 @@ static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
 {
 	return 0;
 }
+
+static inline void *of_irq_find_parent(struct device_node *child)
+{
+	return NULL;
+}
 #endif /* !CONFIG_OF */
 
 #endif /* __OF_IRQ_H */
-- 
1.7.9.5

