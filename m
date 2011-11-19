Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab1KSAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446Ab1KSAJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.585551539@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [19/26] xen:pvhvm: enable PVHVM VCPU placement when using more than 32 CPUs.
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 90d4f5534d14815bd94c10e8ceccc57287657ecc upstream.

PVHVM running with more than 32 vcpus and pv_irq/pv_time enabled
need VCPU placement to work, or else it will softlockup.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1355,7 +1355,7 @@ static int __cpuinit xen_hvm_cpu_notify(
 	int cpu = (long)hcpu;
 	switch (action) {
 	case CPU_UP_PREPARE:
-		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+		xen_vcpu_setup(cpu);
 		if (xen_have_vector_callback)
 			xen_init_lock_cpu(cpu);
 		break;
@@ -1385,7 +1385,6 @@ static void __init xen_hvm_guest_init(vo
 	xen_hvm_smp_init();
 	register_cpu_notifier(&xen_hvm_cpu_notifier);
 	xen_unplug_emulated_devices();
-	have_vcpu_info_placement = 0;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 	xen_hvm_init_time_ops();
 	xen_hvm_init_mmu_ops();


