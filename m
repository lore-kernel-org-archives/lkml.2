Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1CPV0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:26:02 -0400
Received: from kroah.org ([198.145.64.141]:42666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1CPVMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/50] kobject.h: fix build when CONFIG_HOTPLUG is disabled
Date: Wed, 16 Mar 2011 14:11:06 -0700
Message-Id: <1300309888-5028-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_HOTPLUG is not enabled, the inline function add_uevent_var()
needs to have its __attribute__ before the function name/parameters,
otherwise there are syntax errors.

linux-next-20110207/include/linux/kobject.h:232: error: expected ',' or ';' before '{' token

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 15e82c1..9229b64 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -226,9 +226,8 @@ static inline int kobject_uevent_env(struct kobject *kobj,
 				      char *envp[])
 { return 0; }
 
-static inline int add_uevent_var(struct kobj_uevent_env *env,
-				 const char *format, ...)
-	__attribute__((format(printf, 2, 3)))
+static inline __attribute__((format(printf, 2, 3)))
+int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 { return 0; }
 
 static inline int kobject_action_type(const char *buf, size_t count,
-- 
1.7.4.1

