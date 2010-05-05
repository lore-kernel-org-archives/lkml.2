Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab0EEOFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:05:23 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:12106 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492Ab0EEOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:05:17 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzz6ff19h6d525hz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9S1-02-IK6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] KVM: X86: Fix stupid bug in exception reinjection path
Date: Wed, 5 May 2010 16:04:41 +0200
Message-ID: <1273068285-3105-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch merged recently which allowed to mark an exception
as reinjected has a bug as it always marks the exception as
reinjected. This breaks nested-svm shadow-on-shadow
implementation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b2ce1d..c83528e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -277,7 +277,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.nr = nr;
 		vcpu->arch.exception.error_code = error_code;
-		vcpu->arch.exception.reinject = true;
+		vcpu->arch.exception.reinject = reinject;
 		return;
 	}
 
-- 
1.7.1


