Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2KSFaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53952 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2KSFa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:29 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 27/58] x86: apic: Make apic_flat_64.c include asm/apic_flat_64.h for flat_init_apic_ldr prototype
Date: Sun, 18 Nov 2012 21:28:06 -0800
Message-Id: <1353302917-13995-28-git-send-email-josh@joshtriplett.org>
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

arch/x86/kernel/apic/apic_flat_64.c:46:6: warning: no previous prototype for ‘flat_init_apic_ldr’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/apic/apic_flat_64.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 00c77cf..3cdd11a 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <asm/smp.h>
 #include <asm/apic.h>
+#include <asm/apic_flat_64.h>
 #include <asm/ipi.h>
 
 #ifdef CONFIG_ACPI
-- 
1.7.10.4

