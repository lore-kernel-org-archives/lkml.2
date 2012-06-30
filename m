Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2F3XFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 19:05:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2F3XFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 19:05:42 -0400
From: philipspatches@gmail.com
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org,
        Philip Rakity <prakity@marvell.com>
Subject: [PATCH] regulator: add missing defintion regulator_is_supported_voltage
Date: Sat, 30 Jun 2012 16:05:36 -0700
Message-Id: <1341097536-14190-1-git-send-email-prakity@marvell.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Rakity <prakity@marvell.com>

This definition is missing when CONFIG_REGULATOR is not defined.
This causes compiler errors when compiling sdhci.c.  This can
be worked around by adding #ifdef CONFIG_REGULATOR .. #endif
but since other definitions are there we have defined the missing
definition

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 include/linux/regulator/consumer.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 4ed1b30..42eac1c 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -294,6 +294,12 @@ static inline int regulator_get_voltage(struct regulator *regulator)
 	return 0;
 }
 
+static inline int regulator_is_supported_voltage(struct regulator *regulator,
+				   int min_uV, int max_uV)
+{
+	return 0;
+}
+
 static inline int regulator_set_current_limit(struct regulator *regulator,
 					     int min_uA, int max_uA)
 {
-- 
1.7.0.4

