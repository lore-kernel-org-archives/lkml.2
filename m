Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1CPVL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:11:57 -0400
Received: from kroah.org ([198.145.64.141]:42531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1CPVLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/50] kobject: Add missing format attribute specifications
Date: Wed, 16 Mar 2011 14:10:42 -0700
Message-Id: <1300309888-5028-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Several functions in <linux/kobject.h> accept printf-style arguments.
Some of these functions have been annotated with a format attribute
declaration while others have not been annotated. Add a format attribute
specification where it is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 8f6d121..15e82c1 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -85,11 +85,13 @@ static inline const char *kobject_name(const struct kobject *kobj)
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *kobj,
 				    struct kobject *parent,
-				    const char *fmt, ...);
+				    const char *fmt, ...)
+	__attribute__((format(printf, 3, 4)));
 extern int __must_check kobject_init_and_add(struct kobject *kobj,
 					     struct kobj_type *ktype,
 					     struct kobject *parent,
-					     const char *fmt, ...);
+					     const char *fmt, ...)
+	__attribute__((format(printf, 4, 5)));
 
 extern void kobject_del(struct kobject *kobj);
 
@@ -226,6 +228,7 @@ static inline int kobject_uevent_env(struct kobject *kobj,
 
 static inline int add_uevent_var(struct kobj_uevent_env *env,
 				 const char *format, ...)
+	__attribute__((format(printf, 2, 3)))
 { return 0; }
 
 static inline int kobject_action_type(const char *buf, size_t count,
-- 
1.7.4.1

