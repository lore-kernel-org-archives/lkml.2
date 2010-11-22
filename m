Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0KVUui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:50:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60392 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0KVUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:50:37 -0500
Date: Mon, 22 Nov 2010 12:48:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] dmar: use function stubs when CONFIG_INTR_REMAP is disabled
Message-Id: <20101122124834.74429004.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikKAO7TMhYgGU=ggWCTXbvABsgjhmQUPRQB35kL@mail.gmail.com>
References: <AANLkTikKAO7TMhYgGU=ggWCTXbvABsgjhmQUPRQB35kL@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The stubs for CONFIG_INTR_REMAP disabled need to be functions
instead of values to eliminate build warnings.

arch/x86/kernel/apic/apic.c: In function 'lapic_suspend':
arch/x86/kernel/apic/apic.c:2060:3: warning: statement with no effect
arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
arch/x86/kernel/apic/apic.c:2137:3: warning: statement with no effect

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Fabio Comolli <fabio.comolli@gmail.com>
---
 include/linux/dmar.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- lnx-2637-rc3.orig/include/linux/dmar.h
+++ lnx-2637-rc3/include/linux/dmar.h
@@ -175,10 +175,21 @@ static inline int set_msi_sid(struct irt
 	return 0;
 }
 
-#define enable_intr_remapping(mode)	(-1)
-#define disable_intr_remapping()	(0)
-#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
+
+static inline int enable_intr_remapping(int eim)
+{
+	return -1;
+}
+
+static inline void disable_intr_remapping(void)
+{
+}
+
+static inline int reenable_intr_remapping(int eim)
+{
+	return 0;
+}
 #endif
 
 /* Can't use the common MSI interrupt functions
