Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2CLOTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab2CLOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:19:12 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: cmetcalf@tilera.com, torvalds@linux-foundation.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: [PATCH] tile: remove a non-existing header
Date: Mon, 12 Mar 2012 11:18:50 -0300
Message-Id: <1331561930-14964-1-git-send-email-mchehab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing some API changes at the EDAC core, I've tested the EDAC
drivers compilation on all supported architectures, including Tilera.

I noticed that Tilera upstream code has issues: it doesn't compile with
kernel 3.2:

In file included from include/linux/linkage.h:5,
                 from include/linux/kernel.h:13,
                 from include/linux/sched.h:55,
                 from arch/tile/kernel/asm-offsets.c:19:
/home/mchehab/redhat/trees/work/new_edac/arch/tile/include/asm/linkage.h:18:22: error: feedback.h: No such file or directory
make[1]: *** [arch/tile/kernel/asm-offsets.s] Error 1

Without it, it is not possible to compile anything on this archictecture
using this default configuration:
	./arch/tile/configs/tilegx_defconfig

Cc: stable@kernel.org
Signed-of-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

Btw, the ./arch/tile/configs/tilepro_defconfig doesn't compile even
with this fix. It fails at arch/tile/include/asm/atomic_64.h because
atomic64_t is never defined, but it is used there and on other places.

Also, while the edac_tile driver seems to be for both Tile GX and Tilepro
sub-archs, it is not included on tilegx_defconfig. It would make sense
to add it there, in order to make easier for people to test/use the
EDAC drivers.

---
 arch/tile/include/asm/linkage.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/linkage.h b/arch/tile/include/asm/linkage.h
index e121c39..43b298e 100644
--- a/arch/tile/include/asm/linkage.h
+++ b/arch/tile/include/asm/linkage.h
@@ -15,8 +15,6 @@
 #ifndef _ASM_TILE_LINKAGE_H
 #define _ASM_TILE_LINKAGE_H
 
-#include <feedback.h>
-
 #define __ALIGN .align 8
 
 /*
-- 
1.7.8

