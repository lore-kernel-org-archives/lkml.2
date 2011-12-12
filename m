Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1LLNkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:40:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55525 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1LLNkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:40:18 -0500
From: Daniel Baluta <dbaluta@ixiacom.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: marek.belisko@gmail.com, Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] kref: add function for reading kref value
Date: Mon, 12 Dec 2011 15:41:48 +0200
Message-Id: <1323697308-25121-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can easily get kref refcount value by accesing
kref->refcount but it is better to have a function
for this.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 include/linux/kref.h |    1 +
 lib/kref.c           |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index d4a62ab..f2e69c1 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -22,6 +22,7 @@ struct kref {
 };
 
 void kref_init(struct kref *kref);
+int kref_read(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 int kref_sub(struct kref *kref, unsigned int count,
diff --git a/lib/kref.c b/lib/kref.c
index 3efb882..fc7be37 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -26,6 +26,15 @@ void kref_init(struct kref *kref)
 }
 
 /**
+ * kref_read - read refcount for object
+ * @kref: object.
+ */
+int kref_read(struct kref *kref)
+{
+	return atomic_read(&kref->refcount);
+}
+
+/**
  * kref_get - increment refcount for object.
  * @kref: object.
  */
-- 
1.7.1

