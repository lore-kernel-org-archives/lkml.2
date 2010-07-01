Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0GAVBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:01:13 -0400
Received: from kroah.org ([198.145.64.141]:47937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab0GAUv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:27 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:39 2010
Message-Id: <20100701173439.119404626@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Alexander Graf <agraf@suse.de>,
       Avi Kivity <avi@redhat.com>
Subject: [patch 146/164] KVM: PPC: Do not create debugfs if fail to create vcpu
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,7 +181,8 @@ struct kvm_vcpu *kvm_arch_vcpu_create(st
 {
 	struct kvm_vcpu *vcpu;
 	vcpu = kvmppc_core_vcpu_create(kvm, id);
-	kvmppc_create_vcpu_debugfs(vcpu, id);
+	if (!IS_ERR(vcpu))
+		kvmppc_create_vcpu_debugfs(vcpu, id);
 	return vcpu;
 }
 


