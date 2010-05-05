Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab0EECJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:09:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:36932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab0EECJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:09:11 -0400
Date: Wed, 5 May 2010 02:08:46 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-8-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-8-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Fix the types of gsi values
Message-ID: <tip-eddb0c55a14074d6bac8c2ef169aefd7e2c6f139@git.kernel.org>
Git-Commit-ID: eddb0c55a14074d6bac8c2ef169aefd7e2c6f139
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:08:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eddb0c55a14074d6bac8c2ef169aefd7e2c6f139
Gitweb:     http://git.kernel.org/tip/eddb0c55a14074d6bac8c2ef169aefd7e2c6f139
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:09 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:52 -0700

x86, ioapic: Fix the types of gsi values

This patches fixes the types of gsi_base and gsi_end values in
struct mp_ioapic_gsi, and the gsi parameter of mp_find_ioapic
and mp_find_ioapic_pin

A gsi is cannonically a u32, not an int.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-8-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |   10 +++++-----
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 35832a0..feeaf0d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -180,12 +180,12 @@ extern void ioapic_write_entry(int apic, int pin,
 extern void setup_ioapic_ids_from_mpc(void);
 
 struct mp_ioapic_gsi{
-	int gsi_base;
-	int gsi_end;
+	u32 gsi_base;
+	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-int mp_find_ioapic(int gsi);
-int mp_find_ioapic_pin(int ioapic, int gsi);
+int mp_find_ioapic(u32 gsi);
+int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -197,7 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-static inline int mp_find_ioapic(int gsi) { return 0; }
+static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0a053e6..9ab9762 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4247,7 +4247,7 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(int gsi)
+int mp_find_ioapic(u32 gsi)
 {
 	int i = 0;
 
@@ -4262,7 +4262,7 @@ int mp_find_ioapic(int gsi)
 	return -1;
 }
 
-int mp_find_ioapic_pin(int ioapic, int gsi)
+int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	if (WARN_ON(ioapic == -1))
 		return -1;
