Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2ITMNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:13:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2ITMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/32] of/irq: Create stub for of_irq_find_parent when !CONFIG_OF
Date: Thu, 20 Sep 2012 14:12:23 +0200
Message-Id: <1348143170-2130-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
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

Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
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

