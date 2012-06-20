Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2FTPUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:20:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47978 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2FTPUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:20:01 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 0/5] ARM: topology: set the capacity of each cores for big.LITTLE
Date: Wed, 20 Jun 2012 17:19:17 +0200
Message-Id: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates an arch_scale_freq_power function for ARM, which is used 
to set the relative capacity of each core of a big.LITTLE system. It also removes
the broken power estimation of x86.

Modification since v2:
 - set_power_scale function becomes static
 - Rework loop in update_siblings_masks
 - Remove useless code in parse_dt_topology

Modification since v1:
 - Add and update explanation about the use of the table and the range of the value 
 - Remove the use of NR_CPUS and use nr_cpu_ids instead
 - Remove broken power estimation of x86

Peter Zijlstra (1):
  sched, x86: Remove broken power estimation

Vincent Guittot (4):
  ARM: topology: Add arch_scale_freq_power function
  ARM: topology: factorize the update of sibling masks
  ARM: topology: Update cpu_power according to DT information
  sched: cpu_power: enable ARCH_POWER

 arch/arm/kernel/topology.c   |  209 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/Makefile |    2 +-
 arch/x86/kernel/cpu/sched.c  |   55 -----------
 kernel/sched/features.h      |    2 +-
 4 files changed, 189 insertions(+), 79 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/sched.c

-- 
1.7.9.5

