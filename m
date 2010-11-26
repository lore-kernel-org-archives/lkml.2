Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0KZKcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:32:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:43638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0KZKcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:32:12 -0500
Date: Fri, 26 Nov 2010 10:31:38 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, dwmw2@infradead.org, randy.dunlap@oracle.com,
        fabio.comolli@gmail.com, jbarnes@virtuousgeek.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, dwmw2@infradead.org, randy.dunlap@oracle.com,
        fabio.comolli@gmail.com, jbarnes@virtuousgeek.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101122124834.74429004.randy.dunlap@oracle.com>
References: <20101122124834.74429004.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] dmar, x86: Use function stubs when CONFIG_INTR_REMAP is disabled
Message-ID: <tip-4917b284db8607e414c334317b7d15239854d39c@git.kernel.org>
Git-Commit-ID: 4917b284db8607e414c334317b7d15239854d39c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:31:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4917b284db8607e414c334317b7d15239854d39c
Gitweb:     http://git.kernel.org/tip/4917b284db8607e414c334317b7d15239854d39c
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 22 Nov 2010 12:48:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 09:57:36 +0100

dmar, x86: Use function stubs when CONFIG_INTR_REMAP is disabled

The stubs for CONFIG_INTR_REMAP disabled need to be functions
instead of values to eliminate build warnings.

 arch/x86/kernel/apic/apic.c: In function 'lapic_suspend':
 arch/x86/kernel/apic/apic.c:2060:3: warning: statement with no effect
 arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
 arch/x86/kernel/apic/apic.c:2137:3: warning: statement with no effect

Reported-and-Tested-by: Fabio Comolli <fabio.comolli@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <20101122124834.74429004.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/dmar.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index a7d9dc2..7b776d7 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -175,10 +175,21 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
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
