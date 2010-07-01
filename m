Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0GAS2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:28:52 -0400
Received: from kroah.org ([198.145.64.141]:40834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab0GASY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:26 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:18 2010
Message-Id: <20100701173218.037624312@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Alexander Graf <agraf@suse.de>,
       Avi Kivity <avi@redhat.com>
Subject: [patch 133/149] KVM: PPC: Do not create debugfs if fail to create vcpu
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If fail to create the vcpu, we should not create the debugfs
for it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Alexander Graf <agraf@suse.de>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 06056bfb944a0302a8f22eb45f09123de7fb417b)
---
 arch/powerpc/kvm/powerpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -176,7 +176,8 @@ struct kvm_vcpu *kvm_arch_vcpu_create(st
 {
 	struct kvm_vcpu *vcpu;
 	vcpu = kvmppc_core_vcpu_create(kvm, id);
-	kvmppc_create_vcpu_debugfs(vcpu, id);
+	if (!IS_ERR(vcpu))
+		kvmppc_create_vcpu_debugfs(vcpu, id);
 	return vcpu;
 }
 


