Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab0EEOFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:05:21 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:12743
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934285Ab0EEOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:05:17 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9RZ-02-IK2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Important fixes for KVM-AMD
Date: Wed, 5 May 2010 16:04:40 +0200
Message-ID: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here is a set of patches which fix problems in kvm-amd. Patch 1 fixes a
stupid problem with the event-reinjection introduced by me in my
previous patchset.  Patch 2 was a helper to find the bug patch 3 fixes.
I kept it in the patchset because it may be helpful in the future to
debug other problems too. Patch 3 is the most important fix because it
makes kvm-amd on 32 bit hosts work again.  Without this patch the first
vmrum fails with exit-reason VMEXIT_INVALID. Patch 4 fixes the Xen 4.0
shipped with SLES11 in nested svm. The last patch in this series fixes a
potential l2-guest breakout scenario because it may be possible for the
l2-guest to issue hypercalls directly to the host if the l1-hypervisor
does not intercept VMMCALL.

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/msr-index.h |    2 +
 arch/x86/kvm/svm.c               |  108 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c               |    2 +-
 3 files changed, 106 insertions(+), 6 deletions(-)

Shortlog:

Joerg Roedel (5):
      KVM: X86: Fix stupid bug in exception reinjection path
      KVM: SVM: Dump vmcb contents on failed vmrun
      KVM: SVM: Fix wrong intercept masks on 32 bit
      KVM: SVM: Allow EFER.LMSLE to be set with nested svm
      KVM: SVM: Don't allow nested guest to VMMCALL into host


