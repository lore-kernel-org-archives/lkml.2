Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2A2Ca2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 21:30:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46308 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2A2Ca1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 21:30:27 -0500
Message-ID: <1327804218.16295.1.camel@phoenix>
Subject: [PATCH] regulator: Add empty devm_regulator_free for
 !CONFIG_REGULATOR
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 29 Jan 2012 10:30:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we don't have to add #ifdef CONFIG_REGULATOR guards for all the callers of
devm_regulator_free.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/regulator/consumer.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index cef8f04..ad4eae8 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -216,6 +216,10 @@ static inline void regulator_put(struct regulator *regulator)
 {
 }
 
+static inline void devm_regulator_free(struct regulator *regulator)
+{
+}
+
 static inline int regulator_enable(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.5.4



