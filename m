Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0KDK2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:28:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0KDK2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:28:18 -0400
Message-ID: <4CD28BCA.1060907@cn.fujitsu.com>
Date: Thu, 04 Nov 2010 18:32:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
References: <4CD28B5F.1040205@cn.fujitsu.com>
In-Reply-To: <4CD28B5F.1040205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:28:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-04 18:28:49,
	Serialize complete at 2010-11-04 18:28:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nonpaing guest's 'direct_map' is also true, retry #PF for those
guests is useless, so use 'tdp_enabled' instead

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2044302..aacc5eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6174,7 +6174,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
+	if (!tdp_enabled || is_error_page(work->page))
 		return;
 
 	r = kvm_mmu_reload(vcpu);
-- 
1.7.0.4

