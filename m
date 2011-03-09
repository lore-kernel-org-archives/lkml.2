Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1CIWjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:39:53 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:39935 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1CIWjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:39:51 -0500
Date: Wed, 9 Mar 2011 23:36:51 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCHv2] fix regression caused by
	e48672fa25e879f7ae21785c7efd187738139593
Message-ID: <20110309223651.GC1762@pcnci.linuxbox.cz>
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D77F149.8020906@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4796625 records (last update: 20110309)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 387b9f97750444728962b236987fbe8ee8cc4f8c moved kvm_request_guest_time_update(vcpu),
breaking 32bit SMP guests using kvm-clock. Fix this by moving (new) clock update function
to proper place.

Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c27144..ba3f76f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2101,8 +2101,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (check_tsc_unstable()) {
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
 			vcpu->arch.tsc_catchup = 1;
-			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		}
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu != cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
