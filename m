Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2ECWWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:22:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab2ECWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:22:34 -0400
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 2/6] v4l/dvb: fix Kconfig dependencies on VIDEO_CAPTURE_DRIVERS
Date: Thu,  3 May 2012 16:22:23 -0600
Message-Id: <1336083747-3142-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Kconfig warns about unsatisfied dependencies of symbols that
are directly selected.

Many capture drivers depend on DVB capture drivers, which
are hidden behind the CONFIG_DVB_CAPTURE_DRIVERS setting.

The solution here is to enable DVB_CAPTURE_DRIVERS unconditionally
when both DVB and VIDEO_CAPTURE_DRIVERS are enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/dvb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index f6e40b3..c617996 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -29,7 +29,7 @@ config DVB_DYNAMIC_MINORS
 	  If you are unsure about this, say N here.
 
 menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC adapters"
+	bool "DVB/ATSC adapters" if !VIDEO_CAPTURE_DRIVERS
 	depends on DVB_CORE
 	default y
 	---help---
-- 
1.7.5.4

