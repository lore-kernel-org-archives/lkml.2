Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab1GKS6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:58:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:54892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524Ab1GKS6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:58:40 -0400
Date: Mon, 11 Jul 2011 18:58:28 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-bd6a46e087571897f0b2736917500b97d18dac13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Format clean up for IOAPIC output
Git-Commit-ID: bd6a46e087571897f0b2736917500b97d18dac13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Jul 2011 18:58:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd6a46e087571897f0b2736917500b97d18dac13
Gitweb:     http://git.kernel.org/tip/bd6a46e087571897f0b2736917500b97d18dac13
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Fri, 8 Jul 2011 18:46:36 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Jul 2011 16:31:05 +0200

x86, ioapic: Format clean up for IOAPIC output

When IOAPIC data is displayed in "dmesg" with the help of the
boot parameter "apic=debug" certain values are not formatted
correctly wrt their size.

In the "dmesg" snippet below, note that the output for "max
redirection entries", and "IO APIC version" which are each
defined to be just 8-bits long are displayed as 2 bytes in
length. Similarly, "Dst" under the "IRQ redirection table"
should only be 8-bits long.

IO APIC #0......
...
...
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
...
...
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 000 1    0    0   0   0    0    0    00
 01 000 0    0    0   0   0    0    0    31
 02 000 0    0    0   0   0    0    0    30
 03 000 1    0    0   0   0    0    0    33
...
...

Do some formatting clean up, so you will see output like below:

IO APIC #0......
...
...
.... register #01: 00170020
.......     : max redirection entries: 17
.......     : PRQ implemented: 0
.......     : IO APIC version: 20
...
...
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 00  1    0    0   0   0    0    0    00
 01 00  0    0    0   0   0    0    0    31
 02 00  0    0    0   0   0    0    0    30
 03 00  1    0    0   0   0    0    0    33
...
...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/20110708184557.2734.61830.sendpatchset@nchumbalkar.americas.cpqcorp.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 98c8d7e..ed4abaa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1522,10 +1522,12 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
+	printk(KERN_DEBUG ".......     : max redirection entries: %02X\n",
+		reg_01.bits.entries);
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
+	printk(KERN_DEBUG ".......     : IO APIC version: %02X\n",
+		reg_01.bits.version);
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1558,7 +1560,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X ",
+		printk(KERN_DEBUG " %02x %02X  ",
 			i,
 			entry.dest
 		);
