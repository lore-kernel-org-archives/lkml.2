Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0LIUzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:55:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:51988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab0LIUzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:55:45 -0500
Date: Thu, 9 Dec 2010 20:55:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        ebiederm@xmission.com
In-Reply-To: <4CFDF68A.7020902@kernel.org>
References: <4CFDF68A.7020902@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86, apic: Use register_lapic_address() in init_apic_mapping()
Message-ID: <tip-326a2e6bae250b1172c0ae80f3b259d79e9cb56c@git.kernel.org>
Git-Commit-ID: 326a2e6bae250b1172c0ae80f3b259d79e9cb56c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:55:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  326a2e6bae250b1172c0ae80f3b259d79e9cb56c
Gitweb:     http://git.kernel.org/tip/326a2e6bae250b1172c0ae80f3b259d79e9cb56c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 7 Dec 2010 00:55:38 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:05 +0100

x86, apic: Use register_lapic_address() in init_apic_mapping()

Remove the printk as well, we don't want to print when nothing
changed. We print in register_lapic_address() already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
LKML-Reference: <4CFDF68A.7020902@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/apic.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f507f31..9303364 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1655,10 +1655,7 @@ void __init init_apic_mappings(void)
 		 * acpi_register_lapic_address()
 		 */
 		if (!acpi_lapic && !smp_found_config)
-			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-
-		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-					APIC_BASE, apic_phys);
+			register_lapic_address(apic_phys);
 	}
 
 	/*
