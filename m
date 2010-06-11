Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0FKGgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:36:02 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41569 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0FKGgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=K9AvTeKT8xteMlzrVwcxydWqmYDauKWocIZ3Yq2hWzaNuEv0kdLzEq2rpbHbCJNVUm
         BZhY3PPehNz0NLX6qHuUsSFHKWSdsTgrQnUQYDwmLLP08ntejQ8fyKLd3gheYEB19UmZ
         crHzeTjM4k7mtfkDr6cokwhVefOaLp1xDxTqE=
Subject: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS is
 not set
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-9"
Date: Fri, 11 Jun 2010 02:35:48 -0400
Message-ID: <1276238148.22216.30.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current linux-next I got a build error with wlags49_h2 driver when CONFIG_SYSFS is not set.

This patch solves the issue.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/wlags49_h2/wl_sysfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_sysfs.h b/drivers/staging/wlags49_h2/wl_sysfs.h
index 6d96d03..7d5895d 100644
--- a/drivers/staging/wlags49_h2/wl_sysfs.h
+++ b/drivers/staging/wlags49_h2/wl_sysfs.h
@@ -2,6 +2,6 @@
 extern void register_wlags_sysfs(struct net_device *);
 extern void unregister_wlags_sysfs(struct net_device *);
 #else
-static void register_wlags_sysfs(struct net_device *) { return; };
-static void unregister_wlags_sysfs(struct net_device *) { return; };
+#define register_wlags_sysfs(net_device) { }
+#define unregister_wlags_sysfs(net_device) { }
 #endif
-- 
1.7.0.4





