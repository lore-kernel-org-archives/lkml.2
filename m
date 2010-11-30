Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0K3RFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:05:03 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:53521
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab0K3RE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:04:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEW-02-CCS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] KVM: SVM: Wrap access to intercept masks into functions
Date: Tue, 30 Nov 2010 18:03:55 +0100
Message-ID: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Hi Marcelo,

this patchset wraps the access to the intercept vectors in the VMCB into
specific functions. There are two reasons for this:

	1) In the nested-svm code the effective intercept masks are
	   calculated from the host and the guest intercept masks.
	   Whenever KVM changes the host intercept mask while the VCPU
	   is in guest-mode the effective intercept masks need to be
	   re-calculated. This is nicely wrapped into these functions
	   now and makes the code more robust.

	2) These changes make the implementation of the upcoming
	   vmcb-clean-bits feature easier and also more robust (which
	   was the main reason for writing this patchset).

These patches were developed on-top of the patch-set I sent yesterday. I
tested these patches with various guests (Windows-64, Linux 32,32e and
64 as well as with nested-svm).

Regards,

	Joerg

Summary:

 arch/x86/include/asm/svm.h |   44 +++--
 arch/x86/kvm/svm.c         |  391 ++++++++++++++++++++++++--------------------
 2 files changed, 241 insertions(+), 194 deletions(-)

Joerg Roedel (6):
      KVM: SVM: Add function to recalculate intercept masks
      KVM: SVM: Add manipulation functions for CRx intercepts
      KVM: SVM: Add manipulation functions for DRx intercepts
      KVM: SVM: Add manipulation functions for exception intercepts
      KVM: SVM: Add manipulation functions for misc intercepts
      KVM: SVM: Use get_host_vmcb function in svm_get_msr for TSC


