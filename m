Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0HIDLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:11:48 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58760 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0HIDLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:11:46 -0400
Date: Sun, 8 Aug 2010 23:11:42 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sparc: add pdt/of_pdt namespace to pdt code
Message-ID: <20100808231142.61da6c64@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For symbols still lacking namespace qualifiers, add of_pdt to non-static
stuff and pdt_ to static names.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/kernel/leon_kernel.c |    2 +-
 drivers/of/pdt.c                |   40 +++++++++++++++++++-------------------
 include/linux/of_pdt.h          |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
index 6a7b4db..2d51527 100644
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -282,5 +282,5 @@ void __init leon_init_IRQ(void)
 
 void __init leon_init(void)
 {
-	prom_build_more = &leon_node_init;
+	of_pdt_build_more = &leon_node_init;
 }
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 22f46fb..ad31d5d 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -23,7 +23,7 @@
 #include <linux/of_pdt.h>
 #include <asm/prom.h>
 
-void __initdata (*prom_build_more)(struct device_node *dp,
+void __initdata (*of_pdt_build_more)(struct device_node *dp,
 		struct device_node ***nextp);
 
 static struct of_pdt_ops prom_ops __initdata;
@@ -59,7 +59,7 @@ static inline void irq_trans_init(struct device_node *dp)
 
 #endif /* !CONFIG_SPARC */
 
-static struct property * __init build_one_prop(phandle node, char *prev,
+static struct property * __init pdt_build_one_prop(phandle node, char *prev,
 					       char *special_name,
 					       void *special_val,
 					       int special_len)
@@ -110,17 +110,17 @@ static struct property * __init build_one_prop(phandle node, char *prev,
 	return p;
 }
 
-static struct property * __init build_prop_list(phandle node)
+static struct property * __init pdt_build_prop_list(phandle node)
 {
 	struct property *head, *tail;
 
-	head = tail = build_one_prop(node, NULL,
+	head = tail = pdt_build_one_prop(node, NULL,
 				     ".node", &node, sizeof(node));
 
-	tail->next = build_one_prop(node, NULL, NULL, NULL, 0);
+	tail->next = pdt_build_one_prop(node, NULL, NULL, NULL, 0);
 	tail = tail->next;
 	while(tail) {
-		tail->next = build_one_prop(node, tail->name,
+		tail->next = pdt_build_one_prop(node, tail->name,
 					    NULL, NULL, 0);
 		tail = tail->next;
 	}
@@ -128,7 +128,7 @@ static struct property * __init build_prop_list(phandle node)
 	return head;
 }
 
-static char * __init get_one_property(phandle node, const char *name)
+static char * __init pdt_get_one_property(phandle node, const char *name)
 {
 	char *buf = "<NULL>";
 	int len;
@@ -142,7 +142,7 @@ static char * __init get_one_property(phandle node, const char *name)
 	return buf;
 }
 
-static struct device_node * __init prom_create_node(phandle node,
+static struct device_node * __init pdt_create_node(phandle node,
 						    struct device_node *parent)
 {
 	struct device_node *dp;
@@ -156,18 +156,18 @@ static struct device_node * __init prom_create_node(phandle node,
 
 	kref_init(&dp->kref);
 
-	dp->name = get_one_property(node, "name");
-	dp->type = get_one_property(node, "device_type");
+	dp->name = pdt_get_one_property(node, "name");
+	dp->type = pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
 
-	dp->properties = build_prop_list(node);
+	dp->properties = pdt_build_prop_list(node);
 
 	irq_trans_init(dp);
 
 	return dp;
 }
 
-static char * __init build_full_name(struct device_node *dp)
+static char * __init pdt_build_full_name(struct device_node *dp)
 {
 	int len, ourlen, plen;
 	char *n;
@@ -187,7 +187,7 @@ static char * __init build_full_name(struct device_node *dp)
 	return n;
 }
 
-static struct device_node * __init prom_build_tree(struct device_node *parent,
+static struct device_node * __init pdt_build_tree(struct device_node *parent,
 						   phandle node,
 						   struct device_node ***nextp)
 {
@@ -195,7 +195,7 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
 	struct device_node *dp;
 
 	while (1) {
-		dp = prom_create_node(node, parent);
+		dp = pdt_create_node(node, parent);
 		if (!dp)
 			break;
 
@@ -212,12 +212,12 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
 #if defined(CONFIG_SPARC)
 		dp->path_component_name = build_path_component(dp);
 #endif
-		dp->full_name = build_full_name(dp);
+		dp->full_name = pdt_build_full_name(dp);
 
-		dp->child = prom_build_tree(dp, prom_ops.getchild(node), nextp);
+		dp->child = pdt_build_tree(dp, prom_ops.getchild(node), nextp);
 
-		if (prom_build_more)
-			prom_build_more(dp, nextp);
+		if (of_pdt_build_more)
+			of_pdt_build_more(dp, nextp);
 
 		node = prom_ops.getsibling(node);
 	}
@@ -229,12 +229,12 @@ void __init of_pdt_build_devicetree(int root_node)
 {
 	struct device_node **nextp;
 
-	allnodes = prom_create_node(root_node, NULL);
+	allnodes = pdt_create_node(root_node, NULL);
 	allnodes->path_component_name = "";
 	allnodes->full_name = "/";
 
 	nextp = &allnodes->allnext;
-	allnodes->child = prom_build_tree(allnodes,
+	allnodes->child = pdt_build_tree(allnodes,
 			prom_ops.getchild(allnodes->phandle),
 			&nextp);
 }
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
index 1324ba5..ea7a17b 100644
--- a/include/linux/of_pdt.h
+++ b/include/linux/of_pdt.h
@@ -36,7 +36,7 @@ extern void of_pdt_set_ops(struct of_pdt_ops *ops);
 /* for building the device tree */
 extern void of_pdt_build_devicetree(int root_node);
 
-extern void (*prom_build_more)(struct device_node *dp,
+extern void (*of_pdt_build_more)(struct device_node *dp,
 		struct device_node ***nextp);
 
 #endif /* _LINUX_OF_PDT_H */
-- 
1.5.6.5

