Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1CNKx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:53:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39297 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1CNKx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=q7osC+yj0R6HXXcrhgXsuj0HuO9209CVZcWuBW8noIhnMD+eD9c2qVa9EwQhxj6UW0
         vbWxWLUL5hKlH+kPO9iTaRqqly3hz0217O7DMsQJK3bruf/wBmvPTdhUDOogOvZC5T8r
         MMrfZN56a0Rn8zd2Z6Tc77R0Qlmapg1JkfDno=
Subject: [PATCH] platform-driver-x86: fix wrong merge for compal-laptop.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 18:53:14 +0800
Message-ID: <1300099994.3761.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the commit 80183a4b
"compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb to return 1 instead of 0"
has wrong patch merge.

The original patch change the return value for dmi_check_cb():
https://lkml.org/lkml/2010/7/2/88
But commit 80183a4b changed the return value for set_backlight_level.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/compal-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 034572b..f90bdf7 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -275,7 +275,7 @@ static int set_backlight_level(int level)
 
 	ec_write(BACKLIGHT_LEVEL_ADDR, level);
 
-	return 1;
+	return 0;
 }
 
 static int get_backlight_level(void)
@@ -763,7 +763,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
 	printk(KERN_INFO DRIVER_NAME": Identified laptop model '%s'\n",
 		id->ident);
 	extra_features = false;
-	return 0;
+	return 1;
 }
 
 static int dmi_check_cb_extra(const struct dmi_system_id *id)
@@ -772,7 +772,7 @@ static int dmi_check_cb_extra(const struct dmi_system_id *id)
 		"enabling extra features\n",
 		id->ident);
 	extra_features = true;
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata compal_dmi_table[] = {
-- 
1.7.1



