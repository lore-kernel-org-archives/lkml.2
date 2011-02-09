Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1BIR3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:29:53 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46606 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1BIR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:51 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XL-01-3VD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 0/6] KVM support for TSC scaling
Date: Wed, 9 Feb 2011 18:29:38 +0100
Message-ID: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here is the patch-set to implement the TSC-scaling feature of upcoming
AMD CPUs. When this feature is supported the CPU provides a new MSR
which holds a multiplier for the hardware TSC which is applied on the
value rdtsc[p] and reads of MSR 0x10. This feature can be used to
emulate a given tsc frequency for the guest.
Patch 1 is not directly related to this patch-set because it only fixes
a bug which prevented me from testing these patches. In fact it fixes
the same bug Andre sent a patch for. But after the discussion about his
patch he told me to just post my patch and thus here it is.

Thanks,

	Joerg

Diff-stat:

 arch/x86/include/asm/kvm_host.h  |    4 ++
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kvm/svm.c               |   91 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx.c               |   12 +++++
 arch/x86/kvm/x86.c               |   60 ++++++++++++++++++++++---
 include/linux/kvm.h              |    4 ++
 6 files changed, 164 insertions(+), 8 deletions(-)

Shortlog:

Joerg Roedel (6):
      KVM: SVM: Advance instruction pointer in dr_intercept
      KVM: SVM: Implement infrastructure for TSC_RATE_MSR
      KVM: X86: Let kvm-clock report the right tsc frequency
      KVM: SVM: Propagate requested TSC frequency on vcpu init
      KVM: X86: Delegate tsc-offset calculation to architecture code
      KVM: X86: Implement userspace interface to set virtual_tsc_khz


