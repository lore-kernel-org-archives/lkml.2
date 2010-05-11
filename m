Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab0EKQVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0EKQVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:19 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 0/9] pvclock misc fixes - v4.
Date: Tue, 11 May 2010 12:17:38 -0400
Message-Id: <1273594667-17175-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth version ov kvmclock fixes.

Just two minor changes in patch 5, per avi request, and
the addition of cpuid.txt file, documenting all cpuid flags
we use.

As a side effect, this patch removes the time-travel feature
in kvm guests.

Glauber Costa (9):
  Enable pvclock flags in vcpu_time_info structure
  Add a global synchronization point for pvclock
  change msr numbers for kvmclock
  add new KVMCLOCK cpuid feature
  export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
  Try using new kvm clock msrs
  don't compute pvclock adjustments if we trust the tsc
  Tell the guest we'll warn it about tsc stability
  Add cpuid.txt file

 Documentation/kvm/cpuid.txt        |   44 ++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_para.h    |   13 ++++++++
 arch/x86/include/asm/pvclock-abi.h |    4 ++-
 arch/x86/include/asm/pvclock.h     |    1 +
 arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
 arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   44 +++++++++++++++++++++++++++-
 7 files changed, 176 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/kvm/cpuid.txt

