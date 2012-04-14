Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2DNQZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:25:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47566 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2DNQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:25:14 -0400
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 2/2] misc: do not mark exported functions __devexit
Date: Sat, 14 Apr 2012 10:25:04 -0600
Message-Id: <1334420704-22079-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334420704-22079-1-git-send-email-mathieu.poirier@linaro.org>
References: <1334420704-22079-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

No symbol can be exported when the section is discarded - the only
solution I could think of is not to mark symbols as __devexit
when they are exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/misc/ad525x_dpot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 1d1d426..6938f1b 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -749,7 +749,7 @@ exit:
 }
 EXPORT_SYMBOL(ad_dpot_probe);
 
-__devexit int ad_dpot_remove(struct device *dev)
+int ad_dpot_remove(struct device *dev)
 {
 	struct dpot_data *data = dev_get_drvdata(dev);
 	int i;
-- 
1.7.5.4

