Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab1GAVaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab1GAVav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:30:51 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/9] Steal time series again
Date: Fri,  1 Jul 2011 17:22:40 -0400
Message-Id: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here follows the fourth version of the steal time series.
Hope it is acceptable for all involved parties now. The main differences
from v3 are:

* The Changelogs seem to have been writen by an actual person now, not of a
monkey. Yet, I am the aforementioned person, so don't expect much.
* Forcing delayacct on the hypervisor side allow us to simplify the guest
code dramatically, since now we don't need to test for is_idle: if we're idle,
we won't have steal time and end of story.

Hope you enjoy.

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
 Documentation/virtual/kvm/msr.txt     |   35 ++++++++++++++
 arch/ia64/include/asm/paravirt.h      |    4 ++
 arch/ia64/kernel/paravirt.c           |    2 +
 arch/x86/Kconfig                      |   12 +++++
 arch/x86/include/asm/kvm_host.h       |    8 +++
 arch/x86/include/asm/kvm_para.h       |   15 ++++++
 arch/x86/include/asm/paravirt.h       |    9 ++++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/kvm.c                 |   73 ++++++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |    2 +
 arch/x86/kernel/paravirt.c            |    9 ++++
 arch/x86/kvm/Kconfig                  |    1 +
 arch/x86/kvm/x86.c                    |   56 ++++++++++++++++++++++-
 include/linux/kvm_host.h              |    2 +
 kernel/sched.c                        |   80 ++++++++++++++++++++++++++++----
 kernel/sched_features.h               |    4 +-
 virt/kvm/kvm_main.c                   |   20 ++++++++
 18 files changed, 322 insertions(+), 15 deletions(-)

-- 
1.7.3.4

