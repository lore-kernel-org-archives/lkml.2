Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1GDPkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:40:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab1GDPkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:40:40 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/9] Steal time for KVM
Date: Mon,  4 Jul 2011 11:32:19 -0400
Message-Id: <1309793548-16714-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow up on the last series. No significant changes.
Only change is in patch 7/9, where the steal time accounting
function is made inline, and also called from
irqtime_process_acount_tick(). At least in my box ( gcc 4.4.5),
gcc insists in not inlining it. So I am resorting to __always_inline.

Glauber Costa (8):
  KVM-HDR Add constant to represent KVM MSRs enabled bit
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-GST: Add a pv_ops stub for steal time
  add jump labels for ia64 paravirt
  KVM-GST: KVM Steal time accounting
  KVM-GST: adjust scheduler cpu power
  KVM-GST: KVM Steal time registration

Gleb Natapov (1):
  introduce kvm_read_guest_cached

 Documentation/kernel-parameters.txt   |    4 ++
 Documentation/virtual/kvm/msr.txt     |   35 +++++++++++++
 arch/ia64/include/asm/paravirt.h      |    4 ++
 arch/ia64/kernel/paravirt.c           |    2 +
 arch/x86/Kconfig                      |   12 +++++
 arch/x86/include/asm/kvm_host.h       |    8 +++
 arch/x86/include/asm/kvm_para.h       |   15 ++++++
 arch/x86/include/asm/paravirt.h       |    9 +++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/kvm.c                 |   73 +++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |    2 +
 arch/x86/kernel/paravirt.c            |    9 +++
 arch/x86/kvm/Kconfig                  |    1 +
 arch/x86/kvm/x86.c                    |   56 ++++++++++++++++++++-
 include/linux/kvm_host.h              |    2 +
 kernel/sched.c                        |   88 +++++++++++++++++++++++++++++----
 kernel/sched_features.h               |    4 +-
 virt/kvm/kvm_main.c                   |   20 +++++++
 18 files changed, 330 insertions(+), 15 deletions(-)

-- 
1.7.3.4

