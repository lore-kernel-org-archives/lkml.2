Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0FLAG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 20:06:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55874 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0FLAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 20:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=r/MVK8+X3gEuJFA2CFYyDiM0cVF459WxrsqH0DhdmchTPwWZpw445e6UCKBEneLcrD
         v0Zhp5J9WRLHXa8KZVCeyR84J9C2BqP7pwcNelHQ3jukyhA8+DPM0XC6Hqo/8r8vIAhA
         4CwiGni6IrgEVqvjjOQoVOdtvq5SSrHWyDRlw=
Subject: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS is
 not set
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Joe Perches <joe@perches.com>, Henk de Groot <pe1dnn@amsat.org>,
       devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-9"
Date: Fri, 11 Jun 2010 18:18:34 -0400
Message-ID: <1276294714.4942.6.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a build error in linux-next while compiling wlags49_h2 driver when CONFIG_SYSFS not set.

This is the second version of this patch, as Joe recommended I'm using functions instead of macros.

Thanks a lot

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/wlags49_h2/wl_sysfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_sysfs.h b/drivers/staging/wlags49_h2/wl_sysfs.h
index 6d96d03..fa658c3 100644
--- a/drivers/staging/wlags49_h2/wl_sysfs.h
+++ b/drivers/staging/wlags49_h2/wl_sysfs.h
@@ -2,6 +2,6 @@
 extern void register_wlags_sysfs(struct net_device *);
 extern void unregister_wlags_sysfs(struct net_device *);
 #else
-static void register_wlags_sysfs(struct net_device *) { return; };
-static void unregister_wlags_sysfs(struct net_device *) { return; };
+static inline void register_wlags_sysfs(struct net_device *net) { }
+static inline void unregister_wlags_sysfs(struct net_device *net) { }
 #endif
-- 
1.7.0.4




