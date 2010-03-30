Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0C3Xvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:51:44 -0400
Received: from kroah.org ([198.145.64.141]:45812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932439Ab0C3XTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:36 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:37 2010
Message-Id: <20100330224737.353185340@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [027/156] KVM: x86: Add KVM_CAP_X86_ROBUST_SINGLESTEP
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

Commit d2be1651b736002e0c76d7095d6c0ba77b4a897c upstream.

This marks the guest single-step API improvement of 94fe45da and
91586a3b with a capability flag to allow reliable detection by user
space.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c  |    1 +
 include/linux/kvm.h |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1351,6 +1351,7 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_ADJUST_CLOCK:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -497,6 +497,7 @@ struct kvm_ioeventfd {
 #endif
 #define KVM_CAP_S390_PSW 42
 #define KVM_CAP_PPC_SEGSTATE 43
+#define KVM_CAP_X86_ROBUST_SINGLESTEP 51
 
 #ifdef KVM_CAP_IRQ_ROUTING
 


