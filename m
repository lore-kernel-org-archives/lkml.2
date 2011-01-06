Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1AFAzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:55:36 -0500
Received: from kroah.org ([198.145.64.141]:35632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab1AFA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:34 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.901648511@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [045/152] sparc: Remove prom_pathtoinode()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 17d70d6df0c4ea7a203b444001572a91ad9c2bef ]

Unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/oplib_32.h |    1 -
 arch/sparc/include/asm/oplib_64.h |    1 -
 arch/sparc/prom/tree_32.c         |   15 ---------------
 arch/sparc/prom/tree_64.c         |   18 ------------------
 4 files changed, 35 deletions(-)

--- a/arch/sparc/include/asm/oplib_32.h
+++ b/arch/sparc/include/asm/oplib_32.h
@@ -238,7 +238,6 @@ extern int prom_node_has_property(int no
 extern int prom_setprop(int node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(char *path);
 extern int prom_inst2pkg(int);
 
 /* Dorking with Bus ranges... */
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -278,7 +278,6 @@ extern int prom_finddevice(const char *n
 extern int prom_setprop(int node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(const char *path);
 extern int prom_inst2pkg(int);
 extern int prom_service_exists(const char *service_name);
 extern void prom_sun4v_guest_soft_state(void);
--- a/arch/sparc/prom/tree_32.c
+++ b/arch/sparc/prom/tree_32.c
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
--- a/arch/sparc/prom/tree_64.c
+++ b/arch/sparc/prom/tree_64.c
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


