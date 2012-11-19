Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2KSFca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:32:30 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45617 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2KSFc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:27 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 46/58] x86: arch/x86/kernel/irqinit.c: Add prototype for init_IRQ
Date: Sun, 18 Nov 2012 21:28:25 -0800
Message-Id: <1353302917-13995-47-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/irqinit.c defines an __init function init_IRQ, called
from init/main.c.  No header file prototypes init_IRQ, because
init/main.c tends to directly define prototypes for init functions it
calls, rather than including appropriate headers.  So, add a prototype
of init_IRQ to arch/x86/kernel/irqinit.c right above the definition, to
satisfy gcc (-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/irqinit.c:118:116: warning: no previous prototype for ‘init_IRQ’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/irqinit.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 6e03b0d..abc1f55 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -115,6 +115,7 @@ void __init init_ISA_irqs(void)
 		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
 }
 
+void init_IRQ(void);
 void __init init_IRQ(void)
 {
 	int i;
-- 
1.7.10.4

