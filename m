Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0IWKox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:44:53 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:55643 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0IWKow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:44:52 -0400
Date: Thu, 23 Sep 2010 12:44:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH] ds2760_battery: add HAS_IOMEM dependency
Message-ID: <20100923124445.5309c100@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix this Kconfig warning on allmodconfig for s390:

warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet direct dependencies (HAS_IOMEM)

Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/power/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -urpN linux-2.6/drivers/power/Kconfig linux-2.6-patched/drivers/power/Kconfig
--- linux-2.6/drivers/power/Kconfig	2010-09-23 08:47:36.000000000 +0200
+++ linux-2.6-patched/drivers/power/Kconfig	2010-09-23 08:47:39.000000000 +0200
@@ -64,6 +64,7 @@ config TEST_POWER
 
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
+	depends on HAS_IOMEM
 	select W1
 	select W1_SLAVE_DS2760
 	help
