Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2AQNKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:10:07 -0500
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:45425 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753487Ab2AQNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:10:06 -0500
Subject: [PATCH v2] KVM: SVM: comment nested paging and virtualization
 module parameters
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Tue, 17 Jan 2012 14:09:50 +0100
Message-ID: <1326805790.3269.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Also use true instead of 1 for enabling by default.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/svm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fce3ba0..7bbd17c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -182,11 +182,13 @@ static bool npt_enabled = true;
 #else
 static bool npt_enabled;
 #endif
-static int npt = 1;
 
+/* allow nested paging (virtualized MMU) for all guests */
+static int npt = true;
 module_param(npt, int, S_IRUGO);
 
-static int nested = 1;
+/* allow nested virtualization in KVM/SVM */
+static int nested = true;
 module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
-- 
1.7.4.1



