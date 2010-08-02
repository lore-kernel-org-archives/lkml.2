Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0HBQCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:02:03 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64490 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab0HBQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:00 -0400
Date: Mon, 2 Aug 2010 18:01:58 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>, Graf Yang <graf.yang@analog.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Barry Song <barry.song@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/6] arch/blackfin: Remove CONFIG_MEM_GENERIC_BOARD
Message-ID: <8c697ddc279b861006c90dbb320a6079f6c04f92.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEM_GENERIC_BOARD depends on GENERIC_BOARD, but this flag was removed
in 4f25eb85d64640bc656e72917113a84701521b99, therefore all references
to it from the source can be removed

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/Kconfig                |    5 -----
 arch/blackfin/include/asm/mem_init.h |   18 ------------------
 2 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f66294b..8e88316 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -328,11 +328,6 @@ config BF53x
 	depends on (BF531 || BF532 || BF533 || BF534 || BF536 || BF537)
 	default y
 
-config MEM_GENERIC_BOARD
-	bool
-	depends on GENERIC_BOARD
-	default y
-
 config MEM_MT48LC64M4A2FB_7E
 	bool
 	depends on (BFIN533_STAMP)
diff --git a/arch/blackfin/include/asm/mem_init.h b/arch/blackfin/include/asm/mem_init.h
index 7c8fe83..2375799 100644
--- a/arch/blackfin/include/asm/mem_init.h
+++ b/arch/blackfin/include/asm/mem_init.h
@@ -10,7 +10,6 @@
 #if defined(CONFIG_MEM_MT48LC16M16A2TG_75) || \
     defined(CONFIG_MEM_MT48LC64M4A2FB_7E) || \
     defined(CONFIG_MEM_MT48LC16M8A2TG_75) || \
-    defined(CONFIG_MEM_GENERIC_BOARD) || \
     defined(CONFIG_MEM_MT48LC32M8A2_75) || \
     defined(CONFIG_MEM_MT48LC8M32B2B5_7) || \
     defined(CONFIG_MEM_MT48LC32M16A2TG_75) || \
@@ -178,7 +177,6 @@
 
 #if defined(CONFIG_MEM_MT48LC32M8A2_75) || \
     defined(CONFIG_MEM_MT48LC64M4A2FB_7E) || \
-    defined(CONFIG_MEM_GENERIC_BOARD) || \
     defined(CONFIG_MEM_MT48LC32M16A2TG_75) || \
     defined(CONFIG_MEM_MT48LC16M16A2TG_75) || \
     defined(CONFIG_MEM_MT48LC32M8A2_75)
@@ -248,22 +246,6 @@
 #define DDR_tWR		DDR_TWR(MIN_DDR_SCLK(15))
 #endif
 
-#if defined(CONFIG_MEM_GENERIC_BOARD)
-#define DDR_SIZE	DEVSZ_512
-#define DDR_WIDTH	DEVWD_16
-#define DDR_MAX_tCK	13
-
-#define DDR_tRCD	DDR_TRCD(3)
-#define DDR_tWTR	DDR_TWTR(2)
-#define DDR_tWR		DDR_TWR(2)
-#define DDR_tMRD	DDR_TMRD(2)
-#define DDR_tRP		DDR_TRP(3)
-#define DDR_tRAS	DDR_TRAS(7)
-#define DDR_tRC		DDR_TRC(10)
-#define DDR_tRFC	DDR_TRFC(12)
-#define DDR_tREFI	DDR_TREFI(1288)
-#endif
-
 #if (CONFIG_SCLK_HZ < DDR_CLK_HZ(DDR_MAX_tCK))
 # error "CONFIG_SCLK_HZ is too small (<DDR_CLK_HZ(DDR_MAX_tCK) Hz)."
 #elif(CONFIG_SCLK_HZ <= 133333333)
-- 
1.7.0.4

