Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2KSFco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:44 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32967 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2KSFcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:41 -0500
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>, Jan Beulich <jbeulich@suse.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 48/58] x86: arch/x86/kernel/time.c: Include asm/setup.h for setup_default_timer_irq prototype
Date: Sun, 18 Nov 2012 21:28:27 -0800
Message-Id: <1353302917-13995-49-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.
This keeps the types in sync, and eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/time.c:69:116: warning: no previous prototype for ‘setup_default_timer_irq’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 24d3c91..c7cb1b3 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -21,6 +21,7 @@
 #include <asm/timer.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/setup.h>
 
 #ifdef CONFIG_X86_64
 DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
-- 
1.7.10.4

