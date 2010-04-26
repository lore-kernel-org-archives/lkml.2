Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0DZRui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab0DZRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:50:36 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 0/6] pvclock fixes
Date: Mon, 26 Apr 2010 13:46:22 -0400
Message-Id: <1272303988-21929-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the last series I've sent, with comments from you merged.
The first 5 patches are the same, only with the suggested fixes.
I am leaving documentation out, since the basics won't change, and
we're still discussing the details.

Patch 6 is new, and is the guest side of the skipping updates
avi asked for. I haven't yet done any HV work on this
(specially because I am not convinced exactly where it is safe to
do).

Let me know what you think.

Thanks

Glauber Costa (6):
  Enable pvclock flags in vcpu_time_info structure
  Add a global synchronization point for pvclock
  change msr numbers for kvmclock
  export new cpuid KVM_CAP
  Try using new kvm clock msrs
  don't compute pvclock adjustments if we trust the tsc

 arch/x86/include/asm/kvm_para.h    |   13 ++++++++
 arch/x86/include/asm/pvclock-abi.h |    4 ++-
 arch/x86/include/asm/pvclock.h     |    1 +
 arch/x86/kernel/kvmclock.c         |   59 +++++++++++++++++++++++-------------
 arch/x86/kernel/pvclock.c          |   37 ++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   13 +++++++-
 include/linux/kvm.h                |    1 +
 7 files changed, 105 insertions(+), 23 deletions(-)

