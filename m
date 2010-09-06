Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0IFP7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:59:12 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18663
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab0IFP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:51 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L9-02-7A6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 27/27] KVM: SVM: Report Nested Paging support to userspace
Date: Mon, 6 Sep 2010 17:56:06 +0200
Message-ID: <1283788566-29186-28-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the reporting of the nested paging
feature support to userspace.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 932183e..dd6c529 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3478,6 +3478,10 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		if (svm_has(SVM_FEATURE_NRIP))
 			entry->edx |= SVM_FEATURE_NRIP;
 
+		/* Support NPT for the guest if enabled */
+		if (npt_enabled)
+			entry->edx |= SVM_FEATURE_NPT;
+
 		break;
 	}
 }
-- 
1.7.0.4


