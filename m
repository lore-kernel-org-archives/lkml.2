Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2EKIlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:41:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54541 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2EKIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:41:13 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] mfd: lm3533: fix return type of attribute is_visible
Date: Fri, 11 May 2012 10:40:41 +0200
Message-Id: <1336725641-11826-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 587a1f1659 ("switch ->is_visible() to returning umode_t")
the return type of is_visible is umode_t rather than mode_t.

This silences a compiler warning on some architectures where these types
are not compatible.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index d11c891..5770bea 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -359,7 +359,7 @@ static struct attribute *lm3533_attributes[] = {
 #define to_dev_attr(_attr) \
 	container_of(_attr, struct device_attribute, attr)
 
-static mode_t lm3533_attr_is_visible(struct kobject *kobj,
+static umode_t lm3533_attr_is_visible(struct kobject *kobj,
 					     struct attribute *attr, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -367,7 +367,7 @@ static mode_t lm3533_attr_is_visible(struct kobject *kobj,
 	struct device_attribute *dattr = to_dev_attr(attr);
 	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(dattr);
 	enum lm3533_attribute_type type = lattr->type;
-	mode_t mode = attr->mode;
+	umode_t mode = attr->mode;
 
 	if (!lm3533->have_backlights && type == LM3533_ATTR_TYPE_BACKLIGHT)
 		mode = 0;
-- 
1.7.8.5

