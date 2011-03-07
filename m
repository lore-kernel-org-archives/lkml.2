Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1CGKVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:21:14 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:43553 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab1CGKVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:21:12 -0500
Date: Mon, 7 Mar 2011 11:18:27 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH] add missing guest clock update removed by
	e48672fa25e879f7ae21785c7efd187738139593
Message-ID: <20110307101827.GA1762@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4787146 records (last update: 20110307)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e48672fa25e879f7ae21785c7efd187738139593 removed kvm_request_guest_time_update(vcpu);
this breaks 32bit SMP guests using virtio-clock.
thus add unconditional call to kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) to fix the
problem.

Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..4c27144 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2091,6 +2091,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
 		/* Make sure TSC doesn't go backwards */
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :


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
