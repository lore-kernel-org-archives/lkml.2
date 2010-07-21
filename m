Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0GUMuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:50:52 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40098 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0GUMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:50:49 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eMzz1202hzz15d4Rz32i2a8h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L5WRJ4-01-HO9-02
X-M-MSG: 
Date: Wed, 21 Jul 2010 14:47:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, tlb: Correct used type
Message-ID: <20100721124705.GA674@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_processor_id() returns an int and not an unsigned long. Also, since
the function is small enough, there's no need for a local variable
caching its value.

No functionality change, just cleanup.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/mm/tlb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 426f3a1..c03f14a 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -278,11 +278,9 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 
 static void do_flush_tlb_all(void *info)
 {
-	unsigned long cpu = smp_processor_id();
-
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
+		leave_mm(smp_processor_id());
 }
 
 void flush_tlb_all(void)
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

