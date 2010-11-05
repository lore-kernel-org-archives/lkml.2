Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0KEDSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:18:32 -0400
Received: from mail.perches.com ([173.55.12.10]:4037 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab0KEDIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:36 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 03/49] arch/powerpc: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:27 -0700
Message-Id: <5da00d7f95b5c7a96fbfa8420f5e3a8ef33e01e6.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kvm/book3s.c                       |    6 ++----
 arch/powerpc/platforms/cell/spufs/lscsa_alloc.c |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index e316847..4275463 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1307,13 +1307,11 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 	int err = -ENOMEM;
 	unsigned long p;
 
-	vcpu_book3s = vmalloc(sizeof(struct kvmppc_vcpu_book3s));
+	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
 		goto out;
 
-	memset(vcpu_book3s, 0, sizeof(struct kvmppc_vcpu_book3s));
-
-	vcpu_book3s->shadow_vcpu = (struct kvmppc_book3s_shadow_vcpu *)
+	vcpu_book3s->shadow_vcpu =
 		kzalloc(sizeof(*vcpu_book3s->shadow_vcpu), GFP_KERNEL);
 	if (!vcpu_book3s->shadow_vcpu)
 		goto free_vcpu;
diff --git a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
index a101abf..3b894f5 100644
--- a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
+++ b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
@@ -36,10 +36,9 @@ static int spu_alloc_lscsa_std(struct spu_state *csa)
 	struct spu_lscsa *lscsa;
 	unsigned char *p;
 
-	lscsa = vmalloc(sizeof(struct spu_lscsa));
+	lscsa = vzalloc(sizeof(struct spu_lscsa));
 	if (!lscsa)
 		return -ENOMEM;
-	memset(lscsa, 0, sizeof(struct spu_lscsa));
 	csa->lscsa = lscsa;
 
 	/* Set LS pages reserved to allow for user-space mapping. */
-- 
1.7.3.1.g432b3.dirty

