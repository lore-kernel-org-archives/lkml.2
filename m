Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0JaSIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 14:08:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35265 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab0JaSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 14:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U850Q35qJc7wLkpwpTN00ELFcpyAn2uIsFQFI9H0sDbuVpMl2vd4ktgIAqONdFHEqp
         B+1RJL8Lz+6rF+qThZ9VdFHgFRbz+EjE/UinFOSEQptdoxaPGfOw15gbwM1uWyj/C215
         KrGVOilFgoxQ9eYaT9HBUjz1yzezdsX+wT5uQ=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Ben Gamari <bgamari.foss@gmail.com>
Subject: [RFC PATCH] Add Kconfig option for default swappiness
Date: Sun, 31 Oct 2010 14:08:28 -0400
Message-Id: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow distributions to tune this important vm parameter in a more
self-contained manner.

Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
---
 Documentation/sysctl/vm.txt |    2 +-
 mm/Kconfig                  |   11 +++++++++++
 mm/vmscan.c                 |    2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 6c7d18c..792823b 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -614,7 +614,7 @@ This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
 decrease the amount of swap.
 
-The default value is 60.
+The default value is 60 (changed with CONFIG_DEFAULT_SWAPINESS).
 
 ==============================================================
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 9c61158..729ecec 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -61,6 +61,17 @@ config SPARSEMEM_MANUAL
 
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
+	  If unsure, keep default value of 60.
+
 config DISCONTIGMEM
 	def_bool y
 	depends on (!SELECT_MEMORY_MODEL && ARCH_DISCONTIGMEM_ENABLE) || DISCONTIGMEM_MANUAL
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3ff3311..342975f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -126,7 +126,7 @@ struct scan_control {
 /*
  * From 0 .. 100.  Higher means more swappy.
  */
-int vm_swappiness = 60;
+int vm_swappiness = CONFIG_DEFAULT_SWAPPINESS;
 long vm_total_pages;	/* The total number of pages which the VM controls */
 
 static LIST_HEAD(shrinker_list);
-- 
1.7.1

