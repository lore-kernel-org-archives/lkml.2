Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab0EEUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:22:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33678 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab0EEUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:22:37 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       linux-tip-commits@vger.kernel.org
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
	<tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
	<20100505085629.GA16278@elte.hu>
	<j2taca0ce8b1005050236z8448bb27wacebbb2cf2de0fd4@mail.gmail.com>
	<20100505100500.GA12693@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 13:22:25 -0700
In-Reply-To: <20100505100500.GA12693@elte.hu> (Ingo Molnar's message of "Wed\, 5 May 2010 12\:05\:00 +0200")
Message-ID: <m1tyqm14la.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: mingo@elte.hu, linux-tip-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] x86 acpi/irq:  Define gsi_end when X86_IO_APIC is undefined
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oops.  My recent changes introducing a global gsi_end variable failed
to take into account the case of using acpi on a system not built to
support IO_APICs, causing the build to fail.  Define gsi_end to 15 when
CONFIG_X86_IO_APIC is not set to avoid compile errors.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
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
-- 
1.6.5.2.143.g8cc62

