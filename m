Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2FKMPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:15:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38344 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab2FKMPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:15:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 20:14:53 +0800
Message-Id: <1339416893-2683-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: stubs: Make stub regulator_get_voltage() return an error
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returning 0 isn't useful, it's not even meaningful if there is a real
regulator there.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/consumer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index ed05443..bb5b3a2 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -291,7 +291,7 @@ static inline int regulator_set_voltage(struct regulator *regulator,
 
 static inline int regulator_get_voltage(struct regulator *regulator)
 {
-	return 0;
+	return -EINVAL;
 }
 
 static inline int regulator_set_current_limit(struct regulator *regulator,
-- 
1.7.10

