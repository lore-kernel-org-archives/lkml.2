Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2AFQSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:18:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2AFQSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:18:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, yinghai@kernel.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] x86, reboot: typo in nmi reboot path
Date: Fri,  6 Jan 2012 11:17:51 -0500
Message-Id: <1325866671-9797-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was brought to my attention that my x86 change to use NMI in the
reboot path broke Intel Nehalem and Westmere boxes when using kexec.

I realized I had mistyped the if statement in commit
3603a2512f9e69dc87914ba922eb4a0812b21cd6 and stuck the ')' in
the wrong spot.  Putting it in the right spot fixes kexec again.

Doh.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index e72b175..3f3d3f0 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -176,7 +176,7 @@ static void native_nmi_stop_other_cpus(int wait)
 	 */
 	if (num_online_cpus() > 1) {
 		/* did someone beat us here? */
-		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
+		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
 		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-- 
1.7.7.4

