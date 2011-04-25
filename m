Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1DYKOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:14:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab1DYKOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:14:07 -0400
Date: Mon, 25 Apr 2011 10:13:49 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Message-ID: <tip-15d6aba24d88231415f4e7e091c0f1e60c3e6fd5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1303632711-21662-1-git-send-email-avi@redhat.com>
References: <1303632711-21662-1-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Demacro CONFIG_PARAVIRT cpu accessors
Git-Commit-ID: 15d6aba24d88231415f4e7e091c0f1e60c3e6fd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Apr 2011 10:13:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15d6aba24d88231415f4e7e091c0f1e60c3e6fd5
Gitweb:     http://git.kernel.org/tip/15d6aba24d88231415f4e7e091c0f1e60c3e6fd5
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Sun, 24 Apr 2011 11:11:51 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 Apr 2011 13:20:36 +0200

x86: Demacro CONFIG_PARAVIRT cpu accessors

Recently, we had a build failure on !CONFIG_PARAVIRT due to a
callback ->wbinvd() clashing with a macro wbinvd().

While we worked around the issue, avoid it in the future by
changing the macro (and a few surrounding ones) to an inline
function.

Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1303632711-21662-1-git-send-email-avi@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
