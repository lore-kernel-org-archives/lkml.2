Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab1ESUoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:44:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab1ESUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:44:43 -0400
Date: Thu, 19 May 2011 22:44:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm change for v2.6.40
Message-ID: <20110519204436.GA28589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

 Thanks,

	Ingo

------------------>
Avi Kivity (1):
      x86: Demacro CONFIG_PARAVIRT cpu accessors


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
 
