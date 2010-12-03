Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0LCKsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:48:52 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13223
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000Ab0LCKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:22 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWX-02-1ER-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/12] KVM: SVM: Add support for VMCB state caching
Date: Fri, 3 Dec 2010 11:45:47 +0100
Message-ID: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

here is a patch-set which adds support for VMCB state caching to KVM.
This is a new CPU feature where software can mark certain parts of the
VMCB as unchanged since the last vmexit and the hardware can then avoid
reloading these parts from memory.

The feature is implemented downwards-compatible in hardware, so a 0-bit
means the state has changed and needs to be reloaded. This makes it
possible to implement the bits without checking for the feature, as done
in this patch-set (another reason is that the check is as expensive as
clearing the bit). Processors which do not implement VMCB state
caching just ignore these bits.

These patches were tested with multiple guests (Windows, Linux, also in
parallel) and also with nested-svm.

The patches apply on-top of the intercept mask wrapping patch-set I sent
earlier this week. Your feedback is appreciated.

Regards,
	Joerg

 arch/x86/include/asm/svm.h |    6 +++-
 arch/x86/kvm/svm.c         |   70 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 1 deletions(-)

Joerg Roedel (12):
      KVM: SVM: Add clean-bits infrastructure code
      KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count
      KVM: SVM: Add clean-bit for IOPM_BASE and MSRPM_BASE
      KVM: SVM: Add clean-bit for the ASID
      KVM: SVM: Add clean-bit for interrupt state
      KVM: SVM: Add clean-bit for NPT state
      KVM: SVM: Add clean-bit for control registers
      KVM: SVM: Add clean-bit for DR6 and DR7
      KVM: SVM: Add clean-bit for GDT and IDT
      KVM: SVM: Add clean-bit for Segements and CPL
      KVM: SVM: Add clean-bit for CR2 register
      KVM: SVM: Add clean-bit for LBR state


