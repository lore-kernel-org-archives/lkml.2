Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2BCPJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:09:10 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:21281 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2BCPJI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 3 Feb 2012 10:09:08 -0500
Message-Id: <4F2C06A00200007800071071@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 03 Feb 2012 15:09:04 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <dan.magenheimer@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/tmem: cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'bool' for boolean variables. Do proper section placement.
Eliminate an unnecessary export.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>

---
 drivers/xen/tmem.c |   21 ++++++++-------------
 include/xen/tmem.h |    6 +++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

--- 3.3-rc2/drivers/xen/tmem.c
+++ 3.3-rc2-xen-tmem-cleanup/drivers/xen/tmem.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
-#include <linux/module.h>
 #include <linux/cleancache.h>
 
 /* temporary ifdef until include/linux/frontswap.h is upstream */
@@ -128,15 +127,13 @@ static int xen_tmem_flush_object(u32 poo
 	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, oid, 0, 0, 0, 0, 0);
 }
 
-int tmem_enabled __read_mostly;
-EXPORT_SYMBOL(tmem_enabled);
+bool __read_mostly tmem_enabled = false;
 
 static int __init enable_tmem(char *s)
 {
-	tmem_enabled = 1;
+	tmem_enabled = true;
 	return 1;
 }
-
 __setup("tmem", enable_tmem);
 
 #ifdef CONFIG_CLEANCACHE
@@ -229,17 +226,16 @@ static int tmem_cleancache_init_shared_f
 	return xen_tmem_new_pool(shared_uuid, TMEM_POOL_SHARED, pagesize);
 }
 
-static int use_cleancache = 1;
+static bool __initdata use_cleancache = true;
 
 static int __init no_cleancache(char *s)
 {
-	use_cleancache = 0;
+	use_cleancache = false;
 	return 1;
 }
-
 __setup("nocleancache", no_cleancache);
 
-static struct cleancache_ops tmem_cleancache_ops = {
+static struct cleancache_ops __initdata tmem_cleancache_ops = {
 	.put_page = tmem_cleancache_put_page,
 	.get_page = tmem_cleancache_get_page,
 	.flush_page = tmem_cleancache_flush_page,
@@ -356,17 +352,16 @@ static void tmem_frontswap_init(unsigned
 		    xen_tmem_new_pool(private, TMEM_POOL_PERSIST, PAGE_SIZE);
 }
 
-static int __initdata use_frontswap = 1;
+static bool __initdata use_frontswap = true;
 
 static int __init no_frontswap(char *s)
 {
-	use_frontswap = 0;
+	use_frontswap = false;
 	return 1;
 }
-
 __setup("nofrontswap", no_frontswap);
 
-static struct frontswap_ops tmem_frontswap_ops = {
+static struct frontswap_ops __initdata tmem_frontswap_ops = {
 	.put_page = tmem_frontswap_put_page,
 	.get_page = tmem_frontswap_get_page,
 	.flush_page = tmem_frontswap_flush_page,
--- 3.3-rc2/include/xen/tmem.h
+++ 3.3-rc2-xen-tmem-cleanup/include/xen/tmem.h
@@ -1,5 +1,9 @@
 #ifndef _XEN_TMEM_H
 #define _XEN_TMEM_H
+
+#include <linux/types.h>
+
 /* defined in drivers/xen/tmem.c */
-extern int tmem_enabled;
+extern bool tmem_enabled;
+
 #endif /* _XEN_TMEM_H */



