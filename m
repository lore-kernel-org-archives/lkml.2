Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1LLMnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:43:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55177 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1LLMm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:42:59 -0500
From: Daniel Baluta <dbaluta@ixiacom.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] kref: add function for reading kref value
Date: Mon, 12 Dec 2011 14:44:52 +0200
Message-Id: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.1
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
index d4a62ab..cd1b04a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -22,6 +22,7 @@ struct kref {
 };
 
 void kref_init(struct kref *kref);
+atomic_t kref_read(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 int kref_sub(struct kref *kref, unsigned int count,
diff --git a/lib/kref.c b/lib/kref.c
index 3efb882..48aaf2a 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -25,6 +25,15 @@ void kref_init(struct kref *kref)
 	smp_mb();
 }
 
+/**
+ * kref_read - read refcount for object
+ * @kref: object.
+ */
+void kref_read(struct kref *kref)
+{
+	return atomic_read(&kref->refcount);
+}
+
 /**
  * kref_get - increment refcount for object.
  * @kref: object.
-- 
1.7.1

