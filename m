Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab0ECPxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0ECPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:53:50 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH v2 0/7] Pvclock fixes , version two
Date: Mon,  3 May 2010 11:52:00 -0400
Message-Id: <1272901927-829-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a new version of this series.

I am definitely leaving any warp calculations out, as Jeremy wisely
points out that Chuck Norris should perish before we warp.

Also, in this series, I am using KVM_GET_SUPPORTED_CPUID to export
our features to userspace, as avi suggets. (patch 4/7), and starting
to use the flag that indicates possible tsc stability (patch 7/7), although
it is still off by default.

Glauber Costa (7):
  Enable pvclock flags in vcpu_time_info structure
  Add a global synchronization point for pvclock
  change msr numbers for kvmclock
  export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
  Try using new kvm clock msrs
  don't compute pvclock adjustments if we trust the tsc
  Tell the guest we'll warn it about tsc stability

 arch/x86/include/asm/kvm_para.h    |   13 ++++++++
 arch/x86/include/asm/pvclock-abi.h |    4 ++-
 arch/x86/include/asm/pvclock.h     |    1 +
 arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
 arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   37 +++++++++++++++++++++++-
 6 files changed, 125 insertions(+), 23 deletions(-)

