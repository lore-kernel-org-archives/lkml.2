Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1BBBGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:06:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:54690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1BBAnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960470"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [37/139] sparc: Remove prom_pathtoinode()
Message-Id: <20110202004352.849883E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 17d70d6df0c4ea7a203b444001572a91ad9c2bef ]

Unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_32.h |    1 -
 arch/sparc/include/asm/oplib_64.h |    1 -
 arch/sparc/prom/tree_32.c         |   15 ---------------
 arch/sparc/prom/tree_64.c         |   18 ------------------
 4 files changed, 35 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_32.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
@@ -238,7 +238,6 @@ extern int prom_node_has_property(int no
 extern int prom_setprop(int node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(char *path);
 extern int prom_inst2pkg(int);
 
 /* Dorking with Bus ranges... */
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -278,7 +278,6 @@ extern int prom_finddevice(const char *n
 extern int prom_setprop(int node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(const char *path);
 extern int prom_inst2pkg(int);
 extern int prom_service_exists(const char *service_name);
 extern void prom_sun4v_guest_soft_state(void);
Index: linux-2.6.35.y/arch/sparc/prom/tree_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/tree_32.c
+++ linux-2.6.35.y/arch/sparc/prom/tree_32.c
@@ -341,18 +341,3 @@ int prom_inst2pkg(int inst)
 	if (node == -1) return 0;
 	return node;
 }
-
-/* Return 'node' assigned to a particular prom 'path'
- * FIXME: Should work for v0 as well
- */
-int prom_pathtoinode(char *path)
-{
-	int node, inst;
-	
-	inst = prom_devopen (path);
-	if (inst == -1) return 0;
-	node = prom_inst2pkg (inst);
-	prom_devclose (inst);
-	if (node == -1) return 0;
-	return node;
-}
Index: linux-2.6.35.y/arch/sparc/prom/tree_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/tree_64.c
+++ linux-2.6.35.y/arch/sparc/prom/tree_64.c
@@ -374,24 +374,6 @@ inline int prom_inst2pkg(int inst)
 	return node;
 }
 
-/* Return 'node' assigned to a particular prom 'path'
- * FIXME: Should work for v0 as well
- */
-int
-prom_pathtoinode(const char *path)
-{
-	int node, inst;
-
-	inst = prom_devopen (path);
-	if (inst == 0)
-		return 0;
-	node = prom_inst2pkg(inst);
-	prom_devclose(inst);
-	if (node == -1)
-		return 0;
-	return node;
-}
-
 int prom_ihandle2path(int handle, char *buffer, int bufsize)
 {
 	unsigned long args[7];
