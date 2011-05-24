Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1EXTZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:25:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab1EXTZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:25:36 -0400
Date: Tue, 24 May 2011 19:25:10 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-2f344d2e51888785be551a756d8a8aa58269aaa8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, ioapic: Restore ioapic entries during resume properly
Git-Commit-ID: 2f344d2e51888785be551a756d8a8aa58269aaa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 May 2011 19:25:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f344d2e51888785be551a756d8a8aa58269aaa8
Gitweb:     http://git.kernel.org/tip/2f344d2e51888785be551a756d8a8aa58269aaa8
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 24 May 2011 10:45:31 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 May 2011 20:32:41 +0200

x86, ioapic: Restore ioapic entries during resume properly

In mask/restore_ioapic_entries() we should be restoring ioapic
entries when ioapics[apic].saved_registers is not NULL.

Fix the typo and address the resume hang regression reported by
Linus.

This was not found sooner because the systems where these
changes were tested on kept the IO-APIC entries intact over
resume.

Reported-and-tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>
Link: http://lkml.kernel.org/r/1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9488dcf..e529339 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -676,7 +676,7 @@ void mask_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
@@ -699,7 +699,7 @@ int restore_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
