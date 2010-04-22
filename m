Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0DVKen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:34:43 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58879
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753401Ab0DVKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:35 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBJ-01-031-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] More fixes for nested svm
Date: Thu, 22 Apr 2010 12:33:06 +0200
Message-ID: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 22 Apr 2010 10:33:17.0184 (UTC) FILETIME=[385E6800:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here is another set of nested svm fixes. They fix NMI code to make UP Hyper-V
root domain booting. The patches also add better handling for nested entry
failures and mce intercepts.
Also in this patchset are the fixes for the supported cpuid reporting for svm
features. These patches were taken from the nested-npt patchset and slightly
modified. These patches are also marked for -stable backporting.
The probably most important fix is about exception reinjection. This didn't
work reliably before and is fixed with the patch in this series now. This fix
also touches common x86 code but that should be ok because it could be reused
by nested-vmx later.
Please review and give comments (or apply ;-).

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/kvm_host.h |    8 ++++-
 arch/x86/kvm/svm.c              |   72 +++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx.c              |    9 ++++-
 arch/x86/kvm/x86.c              |   26 ++++++++++++--
 4 files changed, 83 insertions(+), 32 deletions(-)

Shortlog:

Joerg Roedel (8):
      KVM: SVM: Fix nested nmi handling
      KVM: SVM: Make sure rip is synced to vmcb before nested vmexit
      KVM: SVM: Sync cr0 and cr3 to kvm state before nested handling
      KVM: SVM: Propagate nested entry failure into guest hypervisor
      KVM: X86: Add callback to let modules decide over some supported cpuid bits
      KVM: SVM: Report emulated SVM features to userspace
      KVM: x86: Allow marking an exception as reinjected
      KVM: SVM: Handle MCE intercepts always on host level


