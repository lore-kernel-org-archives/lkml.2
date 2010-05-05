Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0EEV3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0EEV3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:29:33 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH v3 0/8] pvclock fixes - v3
Date: Wed,  5 May 2010 17:27:11 -0400
Message-Id: <1273094839-18655-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Avi, this version fixes the issues you raised in the last
review. Hopte it is better now.

A cpuid.txt wil follow as soon as we're set on everything, so
I am not including it yet.

Glauber Costa (8):
  Enable pvclock flags in vcpu_time_info structure
  Add a global synchronization point for pvclock
  change msr numbers for kvmclock
  add new KVMCLOCK cpuid feature
  export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
  Try using new kvm clock msrs
  don't compute pvclock adjustments if we trust the tsc
  Tell the guest we'll warn it about tsc stability

 arch/x86/include/asm/kvm_para.h    |   13 ++++++++
 arch/x86/include/asm/pvclock-abi.h |    4 ++-
 arch/x86/include/asm/pvclock.h     |    1 +
 arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
 arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   40 +++++++++++++++++++++++++-
 6 files changed, 128 insertions(+), 23 deletions(-)

