Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0JYPwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:52:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52232 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0JYPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iQBmE+6/amjZ6sBbglVT/BE08NyFRKSOXTSZkZe2rjTZ38jk9K3KWKFfcTw+wKHLR2
         hOS60oeB0um2Ao/xztqFscuDhNMPgtnU0ZkQC/Xzp+2RUk49ph67V6KD2M9gomA2uMWk
         mz0dweLWj2anZD4ASz9oySspMLl5StZc2yz7Q=
From: Namhyung Kim <namhyung@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sparc: don't #include asm/system.h in asm/jump_label.h
Date: Tue, 26 Oct 2010 00:52:36 +0900
Message-Id: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that #include <asm/system.h> makes a circular dependency
between kernel.h and bitmap.h which breaks allmodconfig build.
Removing the line makes no change because jump_label.h doesn't
need it actually AFAICS. Compile tested on sparc32 allmodconfig.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

Failed build log is as following:

  CC      arch/sparc/kernel/asm-offsets.s
In file included from include/linux/cpumask.h:11:0,
                 from arch/sparc/include/asm/smp_32.h:15,
                 from arch/sparc/include/asm/smp.h:6,
                 from arch/sparc/include/asm/system_32.h:12,
                 from arch/sparc/include/asm/system.h:6,
                 from arch/sparc/include/asm/jump_label.h:7,
                 from include/linux/jump_label.h:5,
                 from include/linux/dynamic_debug.h:4,
                 from include/linux/kernel.h:20,
                 from include/linux/sched.h:54,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/bitmap.h: In function 'bitmap_zero':
include/linux/bitmap.h:159:3: error: implicit declaration of function 'DIV_ROUND_UP'
In file included from arch/sparc/include/asm/smp_32.h:15:0,
                 from arch/sparc/include/asm/smp.h:6,
                 from arch/sparc/include/asm/system_32.h:12,
                 from arch/sparc/include/asm/system.h:6,
                 from arch/sparc/include/asm/jump_label.h:7,
                 from include/linux/jump_label.h:5,
                 from include/linux/dynamic_debug.h:4,
                 from include/linux/kernel.h:20,
                 from include/linux/sched.h:54,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/cpumask.h: At top level:
include/linux/cpumask.h:13:26: error: variably modified 'bits' at file scope
include/linux/cpumask.h:659:14: error: variably modified 'cpu_all_bits' at file scope
include/linux/cpumask.h:705:2: error: variably modified 'cpu_bit_bitmap' at file scope
make[3]: *** [arch/sparc/kernel/asm-offsets.s] Error 1
make[2]: *** [prepare0] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2


 arch/sparc/include/asm/jump_label.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 62e66d7..65c0d30 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -4,7 +4,6 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-- 
1.7.0.4

