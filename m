Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2DRKYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:24:34 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:47786 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425Ab2DRKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:24:33 -0400
Subject: [PATCH] KVM: MMU: use page table level macro
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 18 Apr 2012 12:24:29 +0200
Message-ID: <1334744669.2601.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Its much cleaner to use PT_PAGE_TABLE_LEVEL than its numeric value.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/mmu.c         |    2 +-
 arch/x86/kvm/paging_tmpl.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4cb1642..163a008 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3554,7 +3554,7 @@ static bool detect_write_flooding(struct kvm_mmu_page *sp)
 	 * Skip write-flooding detected for the sp whose level is 1, because
 	 * it can become unsync, then the guest page is not write-protected.
 	 */
-	if (sp->role.level == 1)
+	if (sp->role.level == PT_PAGE_TABLE_LEVEL)
 		return false;
 
 	return ++sp->write_flooding_count >= 3;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index df5a703..34f9709 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -658,7 +658,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 {
 	int offset = 0;
 
-	WARN_ON(sp->role.level != 1);
+	WARN_ON(sp->role.level != PT_PAGE_TABLE_LEVEL);
 
 	if (PTTYPE == 32)
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-- 
1.7.4.1



