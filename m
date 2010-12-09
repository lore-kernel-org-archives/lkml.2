Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0LIQto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:49:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:56390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0LIQtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:49:43 -0500
Date: Thu, 9 Dec 2010 16:48:53 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <201010272107.o9RL7rse018212@imap1.linux-foundation.org>
References: <201010272107.o9RL7rse018212@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: io_apic: Avoid unused variable warning when CONFIG_GENERIC_PENDING_IRQ=n
Message-ID: <tip-4720dd1b3858f0da2593188cb1e57eb0d3bc4af2@git.kernel.org>
Git-Commit-ID: 4720dd1b3858f0da2593188cb1e57eb0d3bc4af2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 16:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4720dd1b3858f0da2593188cb1e57eb0d3bc4af2
Gitweb:     http://git.kernel.org/tip/4720dd1b3858f0da2593188cb1e57eb0d3bc4af2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Dec 2010 17:43:21 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 17:43:21 +0100

x86: io_apic: Avoid unused variable warning when CONFIG_GENERIC_PENDING_IRQ=n

arch/x86/kernel/apic/io_apic.c: In function 'ack_apic_level':
arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable 'desc'

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <201010272107.o9RL7rse018212@imap1.linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..226060e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2430,13 +2430,12 @@ static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
