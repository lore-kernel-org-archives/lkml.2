Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1AYNlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:41:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46162 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1AYNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZmpesXWLZt7CRmUJN5EzUuzqMUrXS5qPmD7QvQgPRhnsChMHeRC9gmVMcuyNnempyG
         iepvAkTEgH3JUGMSE2NPSC3jNnLd3lwkw8dI2J+RWZoz2JPjT8xeUoZ23+RiRKCCPbbT
         tpYnBB/SSK5VtXxdTiO/7iZkYPlhW5w5A9J6s=
Subject: [PATCH resend] ifdef gic_present variable that is used only by
 malta
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110125132132.GA25526@linux-mips.org>
References: <1291221075.31413.24.camel@paanoop1-desktop>
	 <20110125132132.GA25526@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 19:27:26 +0530
Message-ID: <1295963846.27661.548.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VSMP kernel build for non-malta platforms fails with following error

  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/mips/built-in.o: In function `vsmp_init_secondary':
smp-mt.c:(.cpuinit.text+0x23cc): undefined reference to `gic_present'
smp-mt.c:(.cpuinit.text+0x23d0): undefined reference to `gic_present'
make: *** [.tmp_vmlinux1] Error 1

gic_present variable is declared only if IRQ_GIC is selected.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/kernel/smp-mt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index c0e8141..54235b5 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -151,6 +151,7 @@ static void vsmp_send_ipi_mask(const struct cpumask
*mask, unsigned int action)
 
 static void __cpuinit vsmp_init_secondary(void)
 {
+#ifdef CONFIG_IRQ_GIC
 	extern int gic_present;
 
 	/* This is Malta specific: IPI,performance and timer interrupts */
@@ -158,6 +159,7 @@ static void __cpuinit vsmp_init_secondary(void)
 		change_c0_status(ST0_IM, STATUSF_IP3 | STATUSF_IP4 |
 					 STATUSF_IP6 | STATUSF_IP7);
 	else
+#endif
 		change_c0_status(ST0_IM, STATUSF_IP0 | STATUSF_IP1 |
 					 STATUSF_IP6 | STATUSF_IP7);
 }
-- 
1.7.0.4



