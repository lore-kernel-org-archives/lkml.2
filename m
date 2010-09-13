Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0IMTsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1843 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0IMTsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:23 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 02/25] arch/powerpc: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:40 -0700
Message-Id: <a2d6296e9aabed2de77ae0b44f16b13008129e48.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/boot/addnote.c    |    4 ++--
 arch/powerpc/boot/cuboot-c2k.c |    4 ++--
 arch/powerpc/kernel/irq.c      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index b1e5611..349b553 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -20,7 +20,7 @@
 #include <string.h>
 
 /* CHRP note section */
-char arch[] = "PowerPC";
+static const char arch[] = "PowerPC";
 
 #define N_DESCR	6
 unsigned int descr[N_DESCR] = {
@@ -33,7 +33,7 @@ unsigned int descr[N_DESCR] = {
 };
 
 /* RPA note section */
-char rpaname[] = "IBM,RPA-Client-Config";
+static const char rpaname[] = "IBM,RPA-Client-Config";
 
 /*
  * Note: setting ignore_my_client_config *should* mean that OF ignores
diff --git a/arch/powerpc/boot/cuboot-c2k.c b/arch/powerpc/boot/cuboot-c2k.c
index e435949..030d7db 100644
--- a/arch/powerpc/boot/cuboot-c2k.c
+++ b/arch/powerpc/boot/cuboot-c2k.c
@@ -62,9 +62,9 @@ static void c2k_bridge_setup(u32 mem_size)
 	/* Get the cpu -> pci i/o & mem mappings from the device tree */
 	devp = NULL;
 	for (bus = 0; ; bus++) {
-		char name[] = "pci ";
+		char name[sizeof("pciX")];
 
-		name[strlen(name)-1] = bus+'0';
+		sprintf(name, "pci%c", bus + '0');
 
 		devp = find_node_by_alias(name);
 		if (devp == NULL)
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 4a65386..47fbc56 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -1143,7 +1143,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 	unsigned long flags;
 	struct irq_desc *desc;
 	const char *p;
-	char none[] = "none";
+	static const char none[] = "none";
 	int i;
 
 	seq_printf(m, "%-5s  %-7s  %-15s  %s\n", "virq", "hwirq",
-- 
1.7.3.rc1

