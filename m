Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1LAATR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:19:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:7689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1LAATQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:19:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,274,1320652800"; 
   d="scan'208";a="42708901"
Message-ID: <4ED6C808.9030003@linux.intel.com>
Date: Wed, 30 Nov 2011 16:19:20 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: [PATCH] trace-cmd: Cross-compile fixes for LDFLAGS and include path
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability for the Makefile to respect LDFLAGS.
Also remove hardcoded /usr/local/include include path.

Signed-off-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>

---
 Makefile |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: git/Makefile
===================================================================
--- git.orig/Makefile
+++ git/Makefile
@@ -202,12 +202,13 @@ export Q VERBOSE
 TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
 KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include $(CONFIG_INCLUDES)
+INCLUDES = -I. $(CONFIG_INCLUDES)
 
 include features.mk
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
+LDFLAGS ?=
 
 ifndef NO_PTRACE
 ifneq ($(call try-cc,$(SOURCE_PTRACE),),y)
@@ -251,7 +252,7 @@ do_fpic_compile =					\
 
 do_app_build =						\
 	($(print_app_build)				\
-	$(CC) $^ -rdynamic -o $@ $(CONFIG_LIBS) $(LIBS))
+	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
@@ -263,7 +264,7 @@ do_compile_plugin_obj =				\
 
 do_plugin_build =				\
 	($(print_plugin_build)			\
-	$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<)
+	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
