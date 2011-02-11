Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1BKRTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:19:49 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:7669 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab1BKRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:19:48 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz8275bh15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGGQSN-01-5Y4-02
X-M-MSG: 
Date: Fri, 11 Feb 2011 18:20:13 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: Fix section mismatch
Message-ID: <20110211172013.GA21088@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark kvm_guest_cpu_online() as __cpuinit since its both users -
kvm_guest_cpu_init() and kvm_cpu_notify() - are __cpuinit too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8dc4466..33c07b0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -493,7 +493,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	native_smp_prepare_boot_cpu();
 }
 
-static void kvm_guest_cpu_online(void *dummy)
+static void __cpuinit kvm_guest_cpu_online(void *dummy)
 {
 	kvm_guest_cpu_init();
 }
-- 
1.7.4.rc2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

