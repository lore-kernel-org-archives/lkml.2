Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0LBQcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:32:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63126 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab0LBQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lCHuHEzDFvGzVMEwImKqhYwPv2wmis369F2gcX6NwP/O9p2cYEgczoeCFfd0pceaOA
         PraPrrKB6ePlaH7+BfAr2VbO9RSo1H1guGW59lvt4vdANb+w5wUtQK0rQuBd6oTH2jdK
         Wev45CAcSOTSihF8sQ6Hj/iawAVrhCIAL+bDs=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 3/4] of/powerpc: Use generic rule to build dtb's
Date: Thu,  2 Dec 2010 08:31:45 -0800
Message-Id: <e1e467f66711f8052abf1e7ff823a5ad6778e0e2.1291231792.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
In-Reply-To: <cover.1291231792.git.dirk.brandewie@gmail.com>
References: <cover.1291231792.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Modify arch/powerpc/boot/Makefile to use dtc command in
scripts/Makefile.lib

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/powerpc/boot/Makefile |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index fae8192..3afb33a 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -35,7 +35,7 @@ endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
 
-DTS_FLAGS	?= -p 1024
+DTC_FLAGS	?= -p 1024
 
 $(obj)/4xx.o: BOOTCFLAGS += -mcpu=405
 $(obj)/ebony.o: BOOTCFLAGS += -mcpu=405
@@ -332,10 +332,8 @@ $(obj)/treeImage.%: vmlinux $(obj)/%.dtb $(wrapperbits)
 	$(call if_changed,wrap,treeboot-$*,,$(obj)/$*.dtb)
 
 # Rule to build device tree blobs
-DTC = $(objtree)/scripts/dtc/dtc
-
-$(obj)/%.dtb: $(dtstree)/%.dts
-	$(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(dtstree)/$*.dts
+$(obj)/%.dtb: $(src)/dts/%.dts
+	$(call if_changed,dtc)
 
 # If there isn't a platform selected then just strip the vmlinux.
 ifeq (,$(image-y))
-- 
1.7.2.3

