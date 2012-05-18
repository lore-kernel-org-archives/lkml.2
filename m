Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232Ab2ERIti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:49:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2ERItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:49:33 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] drivers/w1: cleanup w1_uevent
Date: Fri, 18 May 2012 14:19:23 +0530
Message-Id: <1337330963-20485-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some return statements around in the w1_uevent, used goto
to cleanup those return statements with the help of err variable,
and also removed a semi colon at the end of the w1_uevent's closing
brace.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/w1/w1.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9761950..a0d3c59 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -557,7 +557,7 @@ static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct w1_master *md = NULL;
 	struct w1_slave *sl = NULL;
 	char *event_owner, *name;
-	int err;
+	int err = 0;
 
 	if (dev->driver == &w1_master_driver) {
 		md = container_of(dev, struct w1_master, dev);
@@ -576,19 +576,17 @@ static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
 			event_owner, name, dev_name(dev));
 
 	if (dev->driver != &w1_slave_driver || !sl)
-		return 0;
+		goto end;
 
 	err = add_uevent_var(env, "W1_FID=%02X", sl->reg_num.family);
 	if (err)
-		return err;
+		goto end;
 
 	err = add_uevent_var(env, "W1_SLAVE_ID=%024LX",
 			     (unsigned long long)sl->reg_num.id);
-	if (err)
-		return err;
-
-	return 0;
-};
+end:
+	return err;
+}
 #else
 static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-- 
1.7.9.5

