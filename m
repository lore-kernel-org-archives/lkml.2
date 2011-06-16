Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1FPW2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1FPW2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:28:16 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] Steal time for KVM
Date: Thu, 16 Jun 2011 18:20:49 -0400
Message-Id: <1308262856-5779-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the same series as before, just incorporating the resolutions
we've agreed upon over the list. If you guys are in agreement with me
with what stayed, this series is ready for getting merged, I believe.
Feel free to keep the discussion going otherwise.

Glauber Costa (7):
  KVM-HDR Add constant to represent KVM MSRs enabled bit
  KVM-HDR: KVM Steal time implementation
  KVM-HV: KVM Steal time implementation
  KVM-GST: Add a pv_ops stub for steal time
  KVM-GST: KVM Steal time accounting
  KVM-GST: adjust scheduler cpu power
  KVM-GST: KVM Steal time registration

 Documentation/kernel-parameters.txt   |    4 ++
 Documentation/virtual/kvm/msr.txt     |   33 ++++++++++++
 arch/x86/Kconfig                      |   12 +++++
 arch/x86/include/asm/kvm_host.h       |    8 +++
 arch/x86/include/asm/kvm_para.h       |   15 ++++++
 arch/x86/include/asm/paravirt.h       |    9 +++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/kvm.c                 |   73 +++++++++++++++++++++++++++
 arch/x86/kernel/kvmclock.c            |    2 +
 arch/x86/kernel/paravirt.c            |    9 +++
 arch/x86/kvm/x86.c                    |   60 +++++++++++++++++++++-
 kernel/sched.c                        |   89 +++++++++++++++++++++++++++++---
 kernel/sched_features.h               |    4 +-
 13 files changed, 305 insertions(+), 14 deletions(-)

-- 
1.7.3.4

