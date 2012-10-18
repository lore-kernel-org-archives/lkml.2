Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2JRTHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:07:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41104 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751457Ab2JRTHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:07:04 -0400
Message-ID: <1350587223.5652.4.camel@joe-AO722>
Subject: [PATCH] dynamic_debug: Remove unnecessary __used
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 12:07:03 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __used attribute prevents gcc from eliminating
unnecessary, otherwise optimized away, metadata for
debugging logging messages.

Remove the __used attribute.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/dynamic_debug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index c18257b..6dd4787 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -61,7 +61,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			 const char *fmt, ...);
 
 #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
-	static struct _ddebug __used __aligned(8)		\
+	static struct _ddebug  __aligned(8)			\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
 		.function = __func__,				\


