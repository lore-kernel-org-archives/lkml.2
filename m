Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1HBKfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:35:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59084 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1HBKfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:12 -0400
From: Julia Lawall <julia@diku.dk>
To: Avi Kivity <avi@redhat.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/11] arch/x86/kvm/vmx.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:57 +0200
Message-Id: <1312281304-11847-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/kvm/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4115,8 +4115,7 @@ static int handle_exception(struct kvm_v
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
 		/* EPT won't cause page fault directly */
-		if (enable_ept)
-			BUG();
+		BUG_ON(enable_ept);
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		trace_kvm_page_fault(cr2, error_code);
 

