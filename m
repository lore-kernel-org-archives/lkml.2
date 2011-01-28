Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1A1Txl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:53:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1A1Txi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:53:38 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: [PATCH v2 0/6] KVM Steal time, new submission
Date: Fri, 28 Jan 2011 14:52:14 -0500
Message-Id: <1296244340-15173-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen,

If I may please steal a little bit of your time, for the revision of
this patchset, this is appreciated. This version only includes the steal
time part, using a new MSR+cpuid to register it.

It also includes some documentation, describing the ABI.
Mostly inspired by the kvmclock one.

Comments welcome

Glauber Costa (6):
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-GST: KVM Steal time accounting
  KVM-GST: KVM Steal time registration
  KVM-GST: adjust scheduler cpu power
  Describe KVM_MSR_STEAL_TIME

 Documentation/kvm/msr.txt       |   32 ++++++++++
 arch/x86/Kconfig                |   12 ++++
 arch/x86/include/asm/kvm_host.h |    6 ++
 arch/x86/include/asm/kvm_para.h |   10 +++
 arch/x86/kernel/kvm.c           |   61 +++++++++++++++++++
 arch/x86/kernel/kvmclock.c      |    2 +
 arch/x86/kvm/x86.c              |   48 +++++++++++++--
 include/linux/kvm.h             |    1 +
 include/linux/sched.h           |    1 +
 kernel/sched.c                  |  126 +++++++++++++++++++++++++++++++++++----
 kernel/sched_features.h         |    4 +-
 11 files changed, 283 insertions(+), 20 deletions(-)

-- 
1.7.2.3

