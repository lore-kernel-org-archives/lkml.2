Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0EFKHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:41252 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab0EFKHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:07:21 -0400
Date: Thu, 6 May 2010 10:07:00 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, ebiederm@xmission.com,
       mingo@elte.hu
In-Reply-To: <m1tyqm14la.fsf_-_@fess.ebiederm.org>
References: <m1tyqm14la.fsf_-_@fess.ebiederm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Define gsi_end when X86_IO_APIC is undefined
Message-ID: <tip-4f47b4c9f0b711bf84adb8c27774ae80d346b628@git.kernel.org>
Git-Commit-ID: 4f47b4c9f0b711bf84adb8c27774ae80d346b628
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 10:07:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f47b4c9f0b711bf84adb8c27774ae80d346b628
Gitweb:     http://git.kernel.org/tip/4f47b4c9f0b711bf84adb8c27774ae80d346b628
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Wed, 5 May 2010 13:22:25 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 May 2010 08:17:51 +0200

x86, acpi/irq: Define gsi_end when X86_IO_APIC is undefined

My recent changes introducing a global gsi_end variable
failed to take into account the case of using acpi on a system
not built to support IO_APICs, causing the build to fail.

Define gsi_end to 15 when CONFIG_X86_IO_APIC is not set to avoid
compile errors.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <m1tyqm14la.fsf_-_@fess.ebiederm.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9da192a..63cb409 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -197,6 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
+#define gsi_end (NR_IRQS_LEGACY - 1)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
