Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1AAMwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 07:52:04 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:48853 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AAMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 07:52:01 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kobject: Add missing format attribute specifications
Date: Sat, 1 Jan 2011 13:51:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.6-scst; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101011351.52691.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several functions in <linux/kobject.h> accept printf-style arguments.
Some of these functions have been annotated with a format attribute
declaration while others have not been annotated. Add a format attribute
specification where it is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>

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
1.7.1

