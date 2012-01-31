Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2AaPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:35:51 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:52514 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2AaPfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:35:39 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 V11] Avoid soft lockup message when KVM is stopped by host
Date: Tue, 31 Jan 2012 10:35:28 -0500
Message-Id: <1328024132-7687-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V10:
Return ioctl to per vcpu instead of per vm

Changes from V9:
Use kvm_for_each_vcpu to iterate online vcpu's

Changes from V8:
Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu

Changes from V7:
Define KVM_CAP_GUEST_PAUSED and support check
Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED

Changes from V6:
Use __this_cpu_and when clearing the PVCLOCK_GUEST_STOPPED flag

Changes from V5:
Collapse generic check_and_clear_guest_stopped into patch 2
Include check_and_clear_guest_stopped defintion to ia64, s390, and powerpc
Change check_and_clear_guest_stopped to use __get_cpu_var instead of taking the
 cpuid arg.
Protect check_and_clear_guest_stopped declaration with CONFIG_KVM_CLOCK check

Changes from V4:
Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt

Changes from V3:
Include CC's on patch 3
Drop clear flag ioctl and have the watchdog clear the flag when it is reset

Changes from V2:
A new kvm functions defined in kvm_para.h, the only change to pvclock is the
initial flag definition

Changes from V1:
(Thanks Marcelo)
Host code has all been moved to arch/x86/kvm/x86.c
KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED

Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Eric B Munson (4):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add ioctl for KVMCLOCK_GUEST_STOPPED
  Add check for suspended vm in softlockup detector

 Documentation/virtual/kvm/api.txt   |   13 +++++++++++++
 arch/ia64/include/asm/kvm_para.h    |    5 +++++
 arch/powerpc/include/asm/kvm_para.h |    5 +++++
 arch/s390/include/asm/kvm_para.h    |    5 +++++
 arch/x86/include/asm/kvm_para.h     |    8 ++++++++
 arch/x86/include/asm/pvclock-abi.h  |    1 +
 arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
 arch/x86/kvm/x86.c                  |   21 +++++++++++++++++++++
 include/linux/kvm.h                 |    3 +++
 kernel/watchdog.c                   |   12 ++++++++++++
 10 files changed, 94 insertions(+), 0 deletions(-)

-- 
1.7.5.4

