Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1E3DtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:23 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:53315 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436Ab1E3DtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:22 -0400
X-AuditID: 12074422-b7b0eae000007f48-9a-4de313c46df9
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 01/10] x86-64: Fix alignment of jiffies variable
Date: Sun, 29 May 2011 23:48:38 -0400
Message-Id: <0ea062d74a64a11c587deeee4ca7e9c396a0244f.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsUixG6nrntE+LGvwZ1eIYs569ewWfRdOcpu
	Mesar8XnDf/YLA78espm8f7qdjaLy7vmsFk8ab7OaLHlUjOrxYeJG9gsNm+aymzxqO8tu8WP
	DY9ZHXg9vrf2sXgcO3OY0eNW2x9mj52z7rJ7bF6h5fH/5RE2j02rOtk83p07x+5xYsZvFo/j
	Z5w9Pm+SC+CO4rJJSc3JLEst0rdL4Mr4PG8ta8E71ooFN9rZGxj/sHQxcnJICJhITOrpZoew
	xSQu3FvP1sXIxSEksI9R4ueXc4wQzgZGib1bd4F1CAk8Y5J4NFUBxGYTUJHoWPqAqYuRg0NE
	QF/i6mewemaB58wSDx7uYgWJCws4S1xZ6AVSziKgKrGhbyIziM0rECSx9/d9ZojFChJXrswD
	G88pYCBx8s49qFX6EvNuvWXDJT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXVO93MwS
	vdSU0k2M4PhwUdrB+POg0iFGAQ5GJR5e46JHvkKsiWXFlbmHGCU5mJREeR8JPvYV4kvKT6nM
	SCzOiC8qzUktPsQowcGsJMKr/guonDclsbIqtSgfJiXNwaIkzjtHUt1XSCA9sSQ1OzW1ILUI
	JivDwaEkwftACGioYFFqempFWmZOCUKaiYMTZDgP0HB9kMW8xQWJucWZ6RD5U4y6HI1rdxxk
	FGLJy89LlRLnvQMySACkKKM0D24OLK29YhQHekuY9wpIFQ8wJcJNegW0hAloSe+7hyBLShIR
	UlINjMGzV9UwuS87WXt4o/oRpRl2l1ITL718v75jWcO7wKdpnZ/MObuXrDseEbKGc5p7fuqB
	jDnBD1+/9Zy5dV4Om4K2XdzD/H9XtO2OTiqcmLlaYcmyfBcf4xxfWym+PZw/WS9L1Czbwply
	oPvwwRyh6wpaDH3/i3QVBIKm6c07nPFYuqX8jLQSixJLcUaioRZzUXEiABKmo+dGAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's declared __attribute__((aligned(16)) but it's explicitly not
aligned.  This is probably harmless but it's a but embarrassing.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..a4eaca4 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,7 +45,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-- 
1.7.5.1

