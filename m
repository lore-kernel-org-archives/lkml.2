Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0DONav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:30:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0DONat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:30:49 -0400
Message-ID: <4BC865DA.8020705@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 21:27:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] KVM MMU: smaller reduce 'struct kvm_mmu_page' size
References: <4BC864DD.3000606@cn.fujitsu.com> <4BC8652F.5010006@cn.fujitsu.com> <4BC86591.3050803@cn.fujitsu.com>
In-Reply-To: <4BC86591.3050803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define 'multimapped' as 'bool'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c49c88..cace232 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -202,9 +202,9 @@ struct kvm_mmu_page {
 	 * in this shadow page.
 	 */
 	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
-	int multimapped;         /* More than one parent_pte? */
-	int root_count;          /* Currently serving as active root */
+	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
+	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
-- 
1.6.1.2

