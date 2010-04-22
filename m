Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0DVKeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:34:14 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58879
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753716Ab0DVKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:36 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBN-01-037-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 6/8] KVM: SVM: Report emulated SVM features to userspace
Date: Thu, 22 Apr 2010 12:33:12 +0200
Message-ID: <1271932394-13968-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0153 (UTC) FILETIME=[398ADA10:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the reporting of the emulated SVM
features to userspace instead of the real hardware
capabilities. Every real hardware capability needs emulation
in nested svm so the old behavior was broken.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0fa2035..65fc114 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3154,6 +3154,16 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
+	switch (func) {
+	case 0x8000000A:
+		entry->eax = 1; /* SVM revision 1 */
+		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
+				   ASID emulation to nested SVM */
+		entry->ecx = 0; /* Reserved */
+		entry->edx = 0; /* Do not support any additional features */
+
+		break;
+	}
 }
 
 static const struct trace_print_flags svm_exit_reasons_str[] = {
-- 
1.7.0.4


