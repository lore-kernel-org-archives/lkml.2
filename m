Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952Ab2EJRm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:42:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692Ab2EJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:19 -0400
Message-Id: <20120510173136.201296883@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: [ 38/52] KVM: x86 emulator: correctly mask pmc index bits in RDPMC instruction emulation
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gleb Natapov <gleb@redhat.com>

(cherry picked from commit 270c6c79f4e15e599f47174ecedad932463af7a2)


Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -413,7 +413,7 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vc
 	struct kvm_pmc *counters;
 	u64 ctr;
 
-	pmc &= (3u << 30) - 1;
+	pmc &= ~(3u << 30);
 	if (!fixed && pmc >= pmu->nr_arch_gp_counters)
 		return 1;
 	if (fixed && pmc >= pmu->nr_arch_fixed_counters)


