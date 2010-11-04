Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0KDK0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:26:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50472 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab0KDK0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:26:32 -0400
Message-ID: <4CD28B5F.1040205@cn.fujitsu.com>
Date: Thu, 04 Nov 2010 18:30:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: MMU: fix missing post sync audit
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:27:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:27:02,
	Serialize complete at 2010-11-04 18:27:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AUDIT_POST_SYNC audit for 'root_level == PT64_ROOT_LEVEL' case

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5275c50..f3fad4f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2539,6 +2539,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 		sp = page_header(root);
 		mmu_sync_children(vcpu, sp);
+		trace_kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 		return;
 	}
 	for (i = 0; i < 4; ++i) {
-- 
1.7.0.4
