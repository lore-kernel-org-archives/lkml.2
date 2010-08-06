Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673Ab0HFT2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:28:44 -0400
Received: from kroah.org ([198.145.64.141]:43607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965551Ab0HFT2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:16 2010
Message-Id: <20100806192116.788958141@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [26/36] KVM: MMU: flush remote tlbs when overwriting spte with different pfn
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

(cherry picked from commit 91546356d0e550fa23abf7f4b04a903c2855761f)

After remove a rmap, we should flush all vcpu's tlb

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1901,6 +1901,8 @@ static void mmu_set_spte(struct kvm_vcpu
 			pgprintk("hfn old %lx new %lx\n",
 				 spte_to_pfn(*sptep), pfn);
 			rmap_remove(vcpu->kvm, sptep);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
 			was_rmapped = 1;
 	}


