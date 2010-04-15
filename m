Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0DOSjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0DOSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:39:08 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 0/5] pv clock misc fixes
Date: Thu, 15 Apr 2010 14:37:23 -0400
Message-Id: <1271356648-5108-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

In this series, I present a couple of fixes for kvmclock.
In patch 1, a guest-side fix is proposed for a problem that is biting us
for quite a while now. the tsc inside VMs does not seem to be
that good, (up to now, only single-socket nehalems were stable enough),
and we're seeing small (but nevertheless wrong) time warps inside SMP guests.
I am proposing the fix to reside on common code in pvclock.c, but would
be good to hear Jeremy on this.

On the other 3 patches, I change kvmclock MSR numbers in a compatible
fashion. Both MSR sets will be supported for a while.

Patch 5 adds documentation about kvmclock, which to date, we lacked.

Glauber Costa (5):
  Add a global synchronization point for pvclock
  change msr numbers for kvmclock
  Try using new kvm clock msrs
  export new cpuid KVM_CAP
  add documentation about kvmclock

 Documentation/kvm/kvmclock.txt  |  138 +++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_para.h |   12 +++-
 arch/x86/kernel/kvmclock.c      |   68 +++++++++++++------
 arch/x86/kernel/pvclock.c       |   23 +++++++
 arch/x86/kvm/x86.c              |   13 ++++-
 include/linux/kvm.h             |    1 +
 6 files changed, 231 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/kvm/kvmclock.txt

