Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979Ab0EEIxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:53:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35830 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab0EEIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:53:12 -0400
To: Yinghai <yinghai.lu@oracle.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
	<tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
	<4BE12323.2010104@oracle.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 01:53:03 -0700
In-Reply-To: <4BE12323.2010104@oracle.com> (Yinghai's message of "Wed\, 05 May 2010 00\:49\:55 -0700")
Message-ID: <m1mxwe7ms0.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: yinghai.lu@oracle.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai <yinghai.lu@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] x86 acpi/irq: Fix harmless typo.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


YH noticed that the function irq_to_gsi has an off by one error
when translating high irq numbers to gsis.  Today this bug is harmless
because all of the callers restrict their input to the first 16 irqs
so this bug does not matter, but we should fix it to avoid confusion
and later.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c9a5d3f..78222c8 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -132,7 +132,7 @@ static u32 irq_to_gsi(int irq)
 	else if (irq <= gsi_end)
 		gsi = irq;
 	else if (irq <= (gsi_end + NR_IRQS_LEGACY))
-		gsi = irq - gsi_end;
+		gsi = irq - (gsi_end + 1);
 	else
 		gsi = 0xffffffff;
 
-- 
1.6.5.2.143.g8cc62

