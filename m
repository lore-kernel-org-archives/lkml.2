Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1BEOYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:24:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1BEOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=su3cnTaq2peVx6N+WJmzJNT9/o0bXkXtx+xS04ur/Zt2pSbBeC16NOD/miZr/PwZTe
         Bj8G6qysHmsNFmA1ilYAU0YwNYlH0KIhQxkHe2Q6VRerv2EtNGljOjGZRVqpVGjTrOaW
         wE9vsKZ3JeBba915x+t+TrscKfuE5txxaUTZ4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 47/52] kstrtox: convert mips
Date: Sat,  5 Feb 2011 16:20:50 +0200
Message-Id: <1296915654-7458-47-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/mips/alchemy/devboards/pm.c   |    6 ++----
 arch/mips/alchemy/devboards/prom.c |    2 +-
 arch/mips/alchemy/gpr/init.c       |    2 +-
 arch/mips/alchemy/mtx-1/init.c     |    2 +-
 arch/mips/alchemy/xxs1500/init.c   |    2 +-
 arch/mips/loongson/common/env.c    |    3 +--
 arch/mips/pci/ops-tx4927.c         |    9 +++------
 arch/mips/txx9/generic/setup.c     |    4 +---
 8 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index acaf91b..a833f94 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -158,12 +158,10 @@ static ssize_t db1x_pmattr_store(struct kobject *kobj,
 	int tmp;
 
 	if (ATTRCMP(timer_timeout)) {
-		tmp = strict_strtoul(instr, 0, &l);
+		tmp = kstrtoul(instr, 0, &db1x_pm_sleep_secs);
 		if (tmp)
 			return tmp;
 
-		db1x_pm_sleep_secs = l;
-
 	} else if (ATTRCMP(timer)) {
 		if (instr[0] != '0')
 			db1x_pm_wakemsk |= SYS_WAKEMSK_M2;
@@ -181,7 +179,7 @@ static ssize_t db1x_pmattr_store(struct kobject *kobj,
 		}
 
 	} else if (ATTRCMP(wakemsk)) {
-		tmp = strict_strtoul(instr, 0, &l);
+		tmp = kstrtoul(instr, 0, &l);
 		if (tmp)
 			return tmp;
 
diff --git a/arch/mips/alchemy/devboards/prom.c b/arch/mips/alchemy/devboards/prom.c
index baeb213..e02e0eb 100644
--- a/arch/mips/alchemy/devboards/prom.c
+++ b/arch/mips/alchemy/devboards/prom.c
@@ -54,7 +54,7 @@ void __init prom_init(void)
 
 	prom_init_cmdline();
 	memsize_str = prom_getenv("memsize");
-	if (!memsize_str || strict_strtoul(memsize_str, 0, &memsize))
+	if (!memsize_str || kstrtoul(memsize_str, 0, &memsize))
 		memsize = ALCHEMY_BOARD_DEFAULT_MEMSIZE;
 
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
diff --git a/arch/mips/alchemy/gpr/init.c b/arch/mips/alchemy/gpr/init.c
index f044f4c..a4208de 100644
--- a/arch/mips/alchemy/gpr/init.c
+++ b/arch/mips/alchemy/gpr/init.c
@@ -53,7 +53,7 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtoul(memsize_str, 0, &memsize);
+		kstrtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
 
diff --git a/arch/mips/alchemy/mtx-1/init.c b/arch/mips/alchemy/mtx-1/init.c
index f8d2557..f55f21d 100644
--- a/arch/mips/alchemy/mtx-1/init.c
+++ b/arch/mips/alchemy/mtx-1/init.c
@@ -56,7 +56,7 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtoul(memsize_str, 0, &memsize);
+		kstrtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
 
diff --git a/arch/mips/alchemy/xxs1500/init.c b/arch/mips/alchemy/xxs1500/init.c
index 15125c2..8915bf4 100644
--- a/arch/mips/alchemy/xxs1500/init.c
+++ b/arch/mips/alchemy/xxs1500/init.c
@@ -54,7 +54,7 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtoul(memsize_str, 0, &memsize);
+		kstrtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
 
diff --git a/arch/mips/loongson/common/env.c b/arch/mips/loongson/common/env.c
index 11b193f..49811e1 100644
--- a/arch/mips/loongson/common/env.c
+++ b/arch/mips/loongson/common/env.c
@@ -29,9 +29,8 @@ unsigned long memsize, highmemsize;
 
 #define parse_even_earlier(res, option, p)				\
 do {									\
-	int ret;							\
 	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
-		ret = strict_strtol((char *)p + strlen(option"="), 10, &res); \
+		kstrtol((char *)p + strlen(option"="), 10, &res);	\
 } while (0)
 
 void __init prom_init_env(void)
diff --git a/arch/mips/pci/ops-tx4927.c b/arch/mips/pci/ops-tx4927.c
index a1e7e6d..0af3d73 100644
--- a/arch/mips/pci/ops-tx4927.c
+++ b/arch/mips/pci/ops-tx4927.c
@@ -202,18 +202,15 @@ char *__devinit tx4927_pcibios_setup(char *str)
 	unsigned long val;
 
 	if (!strncmp(str, "trdyto=", 7)) {
-		if (strict_strtoul(str + 7, 0, &val) == 0)
-			tx4927_pci_opts.trdyto = val;
+		kstrtou8(str + 7, 0, &tx4927_pci_opts.trdyto);
 		return NULL;
 	}
 	if (!strncmp(str, "retryto=", 8)) {
-		if (strict_strtoul(str + 8, 0, &val) == 0)
-			tx4927_pci_opts.retryto = val;
+		kstrtou8(str + 8, 0, &tx4927_pci_opts.retryto);
 		return NULL;
 	}
 	if (!strncmp(str, "gbwc=", 5)) {
-		if (strict_strtoul(str + 5, 0, &val) == 0)
-			tx4927_pci_opts.gbwc = val;
+		kstrtou16(str + 5, 0, &tx4927_pci_opts.gbwc);
 		return NULL;
 	}
 	return str;
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 812816c..700f299 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -308,9 +308,7 @@ static void __init preprocess_cmdline(void)
 			txx9_board_vec = find_board_byname(str + 6);
 			continue;
 		} else if (strncmp(str, "masterclk=", 10) == 0) {
-			unsigned long val;
-			if (strict_strtoul(str + 10, 10, &val) == 0)
-				txx9_master_clock = val;
+			kstrtouint(str + 10, 10, &txx9_master_clock);
 			continue;
 		} else if (strcmp(str, "icdisable") == 0) {
 			txx9_ic_disable = 1;
-- 
1.7.3.4

