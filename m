Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab2EQUCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:02:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44638 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932405Ab2EQUCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:02:39 -0400
Message-ID: <1337284958.17726.51.camel@joe2Laptop>
Subject: [RFC PATCH] dynamic_debug: Remove __used attribute from metadata
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 17 May 2012 13:02:38 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __used attribute in the declaration of the
dynamic_debug metadata stops the compiler from
optimizing and eliminating constant tests and
the metadata declaration used in things like:

   #define DEBUG_LEVEL 0
   if (DEBUG_LEVEL > 1)
   	pr_debug("foo...");

This is a common construct for debugging macros
with a constant "level" test.

When dynamic_debug is not configured, this is
pr_debug and format string is eliminated unless
DEBUG_LEVEL is greater than 1.

Remove the unnecessary __used attribute so the
even the dynamic_debug use of pr_debug can be
appropriately optimized away completely.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/dynamic_debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 7e3c53a..85cee11 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -58,7 +58,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			 const char *fmt, ...);
 
 #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
-	static struct _ddebug __used __aligned(8)		\
+	static struct _ddebug __aligned(8)			\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
 		.function = __func__,				\


