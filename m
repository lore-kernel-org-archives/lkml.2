Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0D0Kiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:38:51 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5640 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0D0Kit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:49 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WF-01-32G-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/22] Nested Paging support for Nested SVM v2
Date: Tue, 27 Apr 2010 12:38:10 +0200
Message-ID: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0496 (UTC) FILETIME=[CA29B680:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second and reworked version of my nested paging for nested svm
patchset. Changes to the previous version include:

	* Renamed mmu.tdp_enabled to mmu.direct_map
	* Introduced two helper functions to read physical memory
	  locations of the current running guest level
	* Fixed a couple of bugs were KVM needs to read l2
	  physical memory and others

This patchset is tested with KVM and Windows 7 XPmode. I also tested in KVM
with Linux and Windows 7 as l2 guests. I also tested different pagesize
combinations and did a stress tests for a couple of hours. All these tests
showed no introduced regressions.
Please review this second version of the patch-set. I appreciate your feedback.

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/kvm_host.h |   26 ++++++
 arch/x86/kvm/emulate.c          |   22 +++---
 arch/x86/kvm/mmu.c              |  160 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/mmu.h              |    2 +
 arch/x86/kvm/paging_tmpl.h      |   97 +++++++++++++++++++-----
 arch/x86/kvm/svm.c              |  120 ++++++++++++++++++++++++-----
 arch/x86/kvm/vmx.c              |    3 +
 arch/x86/kvm/x86.c              |   77 +++++++++++++++++--
 include/linux/kvm_host.h        |    5 +
 9 files changed, 423 insertions(+), 89 deletions(-)

Shortlog:

Joerg Roedel (22):
      KVM: MMU: Check for root_level instead of long mode
      KVM: MMU: Make tdp_enabled a mmu-context parameter
      KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
      KVM: X86: Introduce a tdp_set_cr3 function
      KVM: MMU: Introduce get_cr3 function pointer
      KVM: MMU: Introduce inject_page_fault function pointer
      KVM: SVM: Implement MMU helper functions for Nested Nested Paging
      KVM: MMU: Change init_kvm_softmmu to take a context as parameter
      KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
      KVM: MMU: Introduce generic walk_addr function
      KVM: MMU: Add infrastructure for two-level page walker
      KVM: MMU: Implement nested gva_to_gpa functions
      KVM: X86: Add kvm_read_guest_page_tdp function
      KVM: MMU: Make walk_addr_generic capable for two-level walking
      KVM: MMU: Introduce kvm_read_guest_page_x86()
      KVM: MMU: Track page fault data in struct vcpu
      KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
      KVM: X86: Propagate fetch faults
      KVM: MMU: Introduce init_kvm_nested_mmu()
      KVM: SVM: Initialize Nested Nested MMU context on VMRUN
      KVM: SVM: Report Nested Paging support to userspace
      KVM: SVM: Expect two more candiates for exit_int_info


