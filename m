Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0KBDVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:21:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0KBDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Npt4i3btUPgUdaMOa9FhCcvPjqImFbBx2m/dcVllUPs0o/ykbAa0r6eBpOAgXWdMkc
         6oTBl3XuC1VhNCmZ9u13V4FvvhjveIM/rlETE2gDqTGs051WV7C7KOTuQMn4tEaIpWK9
         j1KTxRQJ7ue857Hb0Ms3MJhCVmy3zrrze3ua0=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>
Subject: [PATCH] Add Kconfig option for default swappiness
Date: Mon,  1 Nov 2010 23:20:52 -0400
Message-Id: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow distributions to tune this important vm parameter in a more
self-contained manner.

Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/sysctl/vm.txt |    2 +-
 mm/Kconfig                  |   14 ++++++++++++++
 mm/vmscan.c                 |    2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 30289fa..d159d02 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -643,7 +643,7 @@ This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
 decrease the amount of swap.
 
-The default value is 60.
+The default value is 60 (changed with CONFIG_DEFAULT_SWAPINESS).
 
 ==============================================================
 
diff --git a/mm/Kconfig b/mm/Kconfig
index c2c8a4a..dc23737 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -61,6 +61,20 @@ config SPARSEMEM_MANUAL
 
 endchoice
 
+config DEFAULT_SWAPPINESS
+	int "Default swappiness"
+	default "60"
+	range 0 100
+	help
+	  This control is used to define how aggressive the kernel will swap
+	  memory pages.  Higher values will increase agressiveness, lower
+	  values decrease the amount of swap. Valid values range from 0 to 100.
+
+	  This only sets the default value at boot. Swappiness can be set at
+	  runtime through /proc/sys/vm/swappiness.
+
+	  If unsure, keep default value of 60.
+
 config DISCONTIGMEM
 	def_bool y
 	depends on (!SELECT_MEMORY_MODEL && ARCH_DISCONTIGMEM_ENABLE) || DISCONTIGMEM_MANUAL
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b8a6fdc..d9f5bba 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -133,7 +133,7 @@ struct scan_control {
 /*
  * From 0 .. 100.  Higher means more swappy.
  */
-int vm_swappiness = 60;
+int vm_swappiness = CONFIG_DEFAULT_SWAPPINESS;
 long vm_total_pages;	/* The total number of pages which the VM controls */
 
 static LIST_HEAD(shrinker_list);
-- 
1.7.1

