Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0LQGIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:08:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34505 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0LQGIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xk+0vfdqlGOP9aDHyy6jyE0cbojzpClUYaF4rrrGvV0pBJlxadFVFhiGNOEHKNY27/
         hNtLOpdIKUSHZPtwQNwHrwvztE6/zbfqYUY8YzP4SBum0IJMF8Y/+gGug5qLvg8jwYfM
         Ftu7c+shfC1USESVxkYrnpZmAf1zQ2+ROglMY=
Subject: [PATCH] [ARM] Add missing include "asm/memory.h"
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Fri, 17 Dec 2010 14:08:29 +0800
Message-Id: <1292566109.21261.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error by adding the missing asm/memory.h,
which is needed for arch_is_coherent().

$ make pxa3xx_defconfig; make
  CC      init/do_mounts_rd.o
In file included from include/linux/list_bl.h:5,
                 from include/linux/rculist_bl.h:7,
                 from include/linux/dcache.h:7,
                 from include/linux/fs.h:381,
                 from init/do_mounts_rd.c:3:
include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
include/linux/bit_spinlock.h:61: error: implicit declaration of function 'arch_is_coherent'
make[1]: *** [init/do_mounts_rd.o] Error 1
make: *** [init] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/include/asm/system.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index ec4327a..3222ab8 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -155,6 +155,7 @@ extern unsigned int user_debug;
 #define rmb()		dmb()
 #define wmb()		mb()
 #else
+#include <asm/memory.h>
 #define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
 #define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
 #define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-- 
1.7.2



