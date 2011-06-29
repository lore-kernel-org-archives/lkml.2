Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1F2Phq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab1F2Pho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:37:44 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] Steal time for KVM
Date: Wed, 29 Jun 2011 11:29:39 -0400
Message-Id: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds on the previous one, merging the suggestions
made mainly by Gleb, Peter and Marcelo.

SCHEDSTATS is now used when available to provide information about
time spent on the runqueue for the cpu threads. Information to/from
the guest is obtained using *_cached() functions, as suggested by Gleb.

On the guest side, the two "prev_steal_time" variables are colapsed
into a single one. Steal time accounting is also done inside
update_rq_clock().

Glauber Costa (8):
  KVM-HDR Add constant to represent KVM MSRs enabled bit
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-HV: use schedstats to calculate steal time
  KVM-GST: Add a pv_ops stub for steal time
  KVM-GST: KVM Steal time accounting
  KVM-GST: adjust scheduler cpu power
  KVM-GST: KVM Steal time registration

Gleb Natapov (1):
  introduce kvm_read_guest_cached

 Documentation/kernel-parameters.txt   |    4 ++
 Documentation/virtual/kvm/msr.txt     |   33 ++++++++++++
 arch/x86/Kconfig                      |   12 ++++
 arch/x86/include/asm/kvm_host.h       |    8 +++
 arch/x86/include/asm/kvm_para.h       |   15 +++++
 arch/x86/include/asm/paravirt.h       |    9 +++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/kvm.c                 |   73 +++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |    2 +
 arch/x86/kernel/paravirt.c            |    9 +++
 arch/x86/kvm/x86.c                    |   67 ++++++++++++++++++++++-
 include/linux/kvm_host.h              |    2 +
 kernel/sched.c                        |   94 +++++++++++++++++++++++++++++---
 kernel/sched_features.h               |    4 +-
 virt/kvm/kvm_main.c                   |   20 +++++++
 15 files changed, 339 insertions(+), 14 deletions(-)

-- 
1.7.3.4

