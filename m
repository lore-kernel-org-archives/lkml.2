Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab2KBWDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:03:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2KBWDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:03:01 -0400
Date: Fri, 2 Nov 2012 15:02:37 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-5074b85bdd3a464efe7b6de2ec163f4c07696a20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <5093E00D02000078000A60E2@nat28.tlf.novell.com>
References: <5093E00D02000078000A60E2@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86: hpet:
  Fix inverted return value check in arch_setup_hpet_msi()
Git-Commit-ID: 5074b85bdd3a464efe7b6de2ec163f4c07696a20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Nov 2012 15:02:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5074b85bdd3a464efe7b6de2ec163f4c07696a20
Gitweb:     http://git.kernel.org/tip/5074b85bdd3a464efe7b6de2ec163f4c07696a20
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 14:00:29 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 2 Nov 2012 22:53:27 +0100

x86: hpet: Fix inverted return value check in arch_setup_hpet_msi()

setup_hpet_msi_remapped() returns a negative error indicator on error
- check for this rather than for a boolean false indication, and pass
on that error code rather than a meaningless "-1".

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Link: http://lkml.kernel.org/r/5093E00D02000078000A60E2@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/io_apic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..b134f0b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3317,8 +3317,9 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	int ret;
 
 	if (irq_remapping_enabled) {
-		if (!setup_hpet_msi_remapped(irq, id))
-			return -1;
+		ret = setup_hpet_msi_remapped(irq, id);
+		if (ret)
+			return ret;
 	}
 
 	ret = msi_compose_msg(NULL, irq, &msg, id);
