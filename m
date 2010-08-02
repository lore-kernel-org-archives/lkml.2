Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0HBOpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:45:11 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54018
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751284Ab0HBOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:45:09 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzzz32i87h2a8h)
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6J4WX-02-4IW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Check for asid != 0 on nested vmrun
Date: Mon, 2 Aug 2010 16:46:45 +0200
Message-ID: <1280760405-22591-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com>
References: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets a nested vmrun fail if the L1 hypervisor
left the asid zero. This fixes the asid_zero unit test.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 083fa88..7a2feb9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2020,6 +2020,9 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
+	if (vmcb->control.asid == 0)
+		return false;
+
 	return true;
 }
 
-- 
1.7.0.4


