Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0LCKq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:46:57 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:41320
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932404Ab0LCKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULX0-01-H0I-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/12] KVM: SVM: Add clean-bit for CR2 register
Date: Fri, 3 Dec 2010 11:45:58 +0100
Message-ID: <1291373159-4822-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for the cr2 register in
the vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4c366fe..7643f83 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -196,11 +196,12 @@ enum {
 	VMCB_DR,         /* DR6, DR7 */
 	VMCB_DT,         /* GDT, IDT */
 	VMCB_SEG,        /* CS, DS, SS, ES, CPL */
+	VMCB_CR2,        /* CR2 only */
 	VMCB_DIRTY_MAX,
 };
 
-/* TPR is always written before VMRUN */
-#define VMCB_ALWAYS_DIRTY_MASK	(1U << VMCB_INTR)
+/* TPR and CR2 are always written before VMRUN */
+#define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
 static inline void mark_all_dirty(struct vmcb *vmcb)
 {
-- 
1.7.1


