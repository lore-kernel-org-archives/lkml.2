Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1DXIMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 04:12:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1DXIMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 04:12:10 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: demacro !CONFIG_PARAVIRT cpu accessors
Date: Sun, 24 Apr 2011 11:11:51 +0300
Message-Id: <1303632711-21662-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, we had a build failure on !CONFIG_PARAVIRT due to a callback
->wbinvd() clashing with a macro wbinvd().  While we worked around the
issue, avoid it in the future by changing the macro (and a few surrounding
ones) to an inline function.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/system.h |   85 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 12569e6..c2ff2a1 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -303,24 +303,81 @@ static inline void native_wbinvd(void)
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define read_cr0()	(native_read_cr0())
-#define write_cr0(x)	(native_write_cr0(x))
-#define read_cr2()	(native_read_cr2())
-#define write_cr2(x)	(native_write_cr2(x))
-#define read_cr3()	(native_read_cr3())
-#define write_cr3(x)	(native_write_cr3(x))
-#define read_cr4()	(native_read_cr4())
-#define read_cr4_safe()	(native_read_cr4_safe())
-#define write_cr4(x)	(native_write_cr4(x))
-#define wbinvd()	(native_wbinvd())
+
+static inline unsigned long read_cr0(void)
+{
+	return native_read_cr0();
+}
+
+static inline void write_cr0(unsigned long x)
+{
+	native_write_cr0(x);
+}
+
+static inline unsigned long read_cr2(void)
+{
+	return native_read_cr2();
+}
+
+static inline void write_cr2(unsigned long x)
+{
+	native_write_cr2(x);
+}
+
+static inline unsigned long read_cr3(void)
+{
+	return native_read_cr3();
+}
+
+static inline void write_cr3(unsigned long x)
+{
+	native_write_cr3(x);
+}
+
+static inline unsigned long read_cr4(void)
+{
+	return native_read_cr4();
+}
+
+static inline unsigned long read_cr4_safe(void)
+{
+	return native_read_cr4_safe();
+}
+
+static inline void write_cr4(unsigned long x)
+{
+	native_write_cr4(x);
+}
+
+static inline void wbinvd(void)
+{
+	native_wbinvd();
+}
+
 #ifdef CONFIG_X86_64
-#define read_cr8()	(native_read_cr8())
-#define write_cr8(x)	(native_write_cr8(x))
-#define load_gs_index   native_load_gs_index
+
+static inline unsigned long read_cr8(void)
+{
+	return native_read_cr8();
+}
+
+static inline void write_cr8(unsigned long x)
+{
+	native_write_cr8(x);
+}
+
+static inline void load_gs_index(unsigned selector)
+{
+	native_load_gs_index(selector);
+}
+
 #endif
 
 /* Clear the 'TS' bit */
-#define clts()		(native_clts())
+static inline void clts(void)
+{
+	native_clts();
+}
 
 #endif/* CONFIG_PARAVIRT */
 
-- 
1.7.4.3

