Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0D0KjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:03 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14125
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754698Ab0D0Ki6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:58 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WN-01-32U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/22] KVM: SVM: Report Nested Paging support to userspace
Date: Tue, 27 Apr 2010 12:38:31 +0200
Message-ID: <1272364712-17425-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0230 (UTC) FILETIME=[CA99B660:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the reporting of the nested paging
feature support to userspace.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 266b1d4..6d6b300 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3233,7 +3233,12 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
 				   ASID emulation to nested SVM */
 		entry->ecx = 0; /* Reserved */
-		entry->edx = 0; /* Do not support any additional features */
+		entry->edx = 0; /* Per default do not support any
+				   additional features */
+
+		/* Support NPT for the guest if enabled */
+		if (npt_enabled)
+			entry->edx = SVM_FEATURE_NPT;
 
 		break;
 	}
-- 
1.7.0.4


