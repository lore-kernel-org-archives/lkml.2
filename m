Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0FTRTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 13:19:14 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:59197 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500Ab0FTRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 13:19:10 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 193009BF7F
Subject: [PATCH] HID: Fixing offset errors in bin_attribute read functions
 of roccat kone
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 19:19:06 +0200
Message-ID: <1277054346.10971.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing wrong calculated offsets in bin_attribute read functions.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index fcc2ccc..f776957 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -272,7 +272,7 @@ static ssize_t kone_sysfs_read_settings(struct file *fp, struct kobject *kobj,
 		count = sizeof(struct kone_settings) - off;
 
 	mutex_lock(&kone->kone_lock);
-	memcpy(buf, &kone->settings + off, count);
+	memcpy(buf, ((char const *)&kone->settings) + off, count);
 	mutex_unlock(&kone->kone_lock);
 
 	return count;
@@ -332,7 +332,7 @@ static ssize_t kone_sysfs_read_profilex(struct kobject *kobj,
 		count = sizeof(struct kone_profile) - off;
 
 	mutex_lock(&kone->kone_lock);
-	memcpy(buf, &kone->profiles[number - 1], sizeof(struct kone_profile));
+	memcpy(buf, ((char const *)&kone->profiles[number - 1]) + off, count);
 	mutex_unlock(&kone->kone_lock);
 
 	return count;
-- 
1.6.6.1



