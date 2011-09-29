Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1I2UfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:35:23 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33756 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757849Ab1I2UfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:35:18 -0400
Message-ID: <4E84D684.107@xenotime.net>
Date: Thu, 29 Sep 2011 13:35:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH -next] x86 mrst: fix build error when X86_MRST is not enabled
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
In-Reply-To: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build when CONFIG_X86_INTEL_MID is enabled but
CONFIG_X86_MRST is not enabled.  Fixes this build error:

rtc.c:(.init.text+0x2fbb): undefined reference to `__mrst_cpu_chip'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/include/asm/mrst.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- next-2011-0929.orig/arch/x86/include/asm/mrst.h
+++ next-2011-0929/arch/x86/include/asm/mrst.h
@@ -32,18 +32,18 @@ enum mrst_cpu_type {
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
 
-#ifdef CONFIG_X86_INTEL_MID
+#ifdef CONFIG_X86_MRST
 
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
 
-#else /* !CONFIG_X86_INTEL_MID */
+#else /* !CONFIG_X86_MRST */
 
 #define mrst_identify_cpu()    (0)
 
-#endif /* !CONFIG_X86_INTEL_MID */
+#endif /* !CONFIG_X86_MRST */
 
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
