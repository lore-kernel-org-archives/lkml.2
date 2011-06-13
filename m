Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1FMXiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1FMXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:38:49 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] KVM steal time implementation
Date: Mon, 13 Jun 2011 19:31:30 -0400
Message-Id: <1308007897-17013-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is a repost of the last series I posted about this.
It tries to address most concerns that were raised at the time,
plus makes uses of the static_branch interface to disable the
steal code when not in use.


Glauber Costa (7):
  KVM-HDR Add constant to represent KVM MSRs enabled bit
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-GST: Add a pv_ops stub for steal time
  KVM-GST: KVM Steal time accounting
  KVM-GST: adjust scheduler cpu power
  KVM-GST: KVM Steal time registration

 Documentation/kernel-parameters.txt   |    4 ++
 Documentation/virtual/kvm/msr.txt     |   33 +++++++++++++
 arch/x86/Kconfig                      |   12 +++++
 arch/x86/include/asm/kvm_host.h       |    8 +++
 arch/x86/include/asm/kvm_para.h       |   15 ++++++
 arch/x86/include/asm/paravirt.h       |    9 ++++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/kvm.c                 |   72 +++++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |    2 +
 arch/x86/kernel/paravirt.c            |    9 ++++
 arch/x86/kvm/x86.c                    |   60 +++++++++++++++++++++++-
 kernel/sched.c                        |   81 +++++++++++++++++++++++++++++----
 kernel/sched_features.h               |    4 +-
 13 files changed, 296 insertions(+), 14 deletions(-)

-- 
1.7.3.4

