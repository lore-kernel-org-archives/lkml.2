Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2FGSsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:48:22 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:54127 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab2FGSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:47:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, Philippe De Muyter <phdm@macqel.be>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/5] m68k: delay, muldi3 - Use CONFIG_CPU_HAS_NO_MULDIV64
Date: Thu,  7 Jun 2012 20:47:05 +0200
Message-Id: <1339094827-12349-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of open coding CONFIG_M68000 || CONFIG_COLDFIRE

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/delay.h |    2 +-
 arch/m68k/lib/muldi3.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/delay.h b/arch/m68k/include/asm/delay.h
index 9c09bec..12d8fe4 100644
--- a/arch/m68k/include/asm/delay.h
+++ b/arch/m68k/include/asm/delay.h
@@ -43,7 +43,7 @@ static inline void __delay(unsigned long loops)
 extern void __bad_udelay(void);
 
 
-#if defined(CONFIG_M68000) || defined(CONFIG_COLDFIRE)
+#ifdef CONFIG_CPU_HAS_NO_MULDIV64
 /*
  * The simpler m68k and ColdFire processors do not have a 32*32->64
  * multiply instruction. So we need to handle them a little differently.
diff --git a/arch/m68k/lib/muldi3.c b/arch/m68k/lib/muldi3.c
index 79e928a..ee5f0b1 100644
--- a/arch/m68k/lib/muldi3.c
+++ b/arch/m68k/lib/muldi3.c
@@ -19,7 +19,7 @@ along with GNU CC; see the file COPYING.  If not, write to
 the Free Software Foundation, 59 Temple Place - Suite 330,
 Boston, MA 02111-1307, USA.  */
 
-#if defined(CONFIG_M68000) || defined(CONFIG_COLDFIRE)
+#ifdef CONFIG_CPU_HAS_NO_MULDIV64
 
 #define SI_TYPE_SIZE 32
 #define __BITS4 (SI_TYPE_SIZE / 4)
-- 
1.7.0.4

