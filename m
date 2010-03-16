Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937380Ab0CPCYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:24:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0CPCYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:24:48 -0400
Message-ID: <4B9FCC42.2080709@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 02:21:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM MMU: check reserved bits only if CR4.PSE=1 or CR4.PAE=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RSV bit is possibility set in error code when #PF occurred
only if CR4.PSE=1 or CR4.PAE=1

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 741373e..36e50ab 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2270,6 +2270,9 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 {
 	int bit7;
 
+	if (!is_pae(vcpu) && !is_pse(vcpu))
+		return 0;
+
 	bit7 = (gpte >> 7) & 1;
 	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
 }
-- 
1.6.1.2

