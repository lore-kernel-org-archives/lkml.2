Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1BHACu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:02:50 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56919 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab1BHACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:02:39 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 3/3] module: do not hide __modver_version_show declaration behind ifdef
Date: Mon,  7 Feb 2011 16:02:27 -0800
Message-Id: <1297123347-2170-3-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1297123347-2170-1-git-send-email-dtor@vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing so prevents the following warning from sparse:

  CHECK   kernel/params.c
kernel/params.c:817:9: warning: symbol '__modver_version_show' was not
declared. Should it be static?

since kernel/params.c is never compiled with MODULE being set.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/module.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 9b7081a..cb41837 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -64,6 +64,9 @@ struct module_version_attribute {
 	const char *version;
 };
 
+extern ssize_t __modver_version_show(struct module_attribute *,
+				     struct module *, char *);
+
 struct module_kobject
 {
 	struct kobject kobj;
@@ -172,8 +175,6 @@ extern struct module __this_module;
 #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
 #else
 #define MODULE_VERSION(_version)					\
-	extern ssize_t __modver_version_show(struct module_attribute *,	\
-					     struct module *, char *);	\
 	static struct module_version_attribute ___modver_attr = {	\
 		.mattr	= {						\
 			.attr	= {					\
-- 
1.7.3.2

