Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2KSFcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:22 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45656 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2KSFcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:19 -0500
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 45/58] x86: Fix prototype for renamed function smp_threshold_interrupt
Date: Sun, 18 Nov 2012 21:28:24 -0800
Message-Id: <1353302917-13995-46-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7856f6cce4a8cda8c1f94b99605c07d16b8d8dec renamed
mce_threshold_interrupt to smp_threshold_interrupt, but did not update
the prototype in arch/x86/include/asm/traps.h to match.  Update the
prototype to the new name.

This also eliminates warnings from GCC (-Wmissing-prototypes) and Sparse
(-Wdecl).

arch/x86/kernel/traps.c:597:29: warning: no previous prototype for ‘smp_threshold_interrupt’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/traps.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..914309a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -86,7 +86,7 @@ void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
-asmlinkage void mce_threshold_interrupt(void);
+asmlinkage void smp_threshold_interrupt(void);
 #endif
 
 /* Interrupts/Exceptions */
-- 
1.7.10.4

