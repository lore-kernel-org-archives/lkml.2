Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1KQLcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:32:50 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56195 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab1KQLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:32:49 -0500
Subject: [RFC PATCH v2 0/4] cpuidle: (POWER) cpuidle driver for pSeries
To: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 17 Nov 2011 16:58:25 +0530
Message-ID: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111711-2000-0000-0000-000001C9075F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series ports the cpuidle framework for ppc64 platform and
implements a cpuidle back-end driver for ppc64 (pSeries) platform.
Currently idle states are managed by pseries_{dedicated,shared}_idle_sleep()
routines in arch/powerpc/platforms/pseries/setup.c.  There are
two idle states (snooze and cede) that are exploited by
these routines based on simple heuristics.

Moving the idle states over to cpuidle framework can take advantage of
the advanced heuristics, tunables, and features provided by cpuidle
framework. Additional idle states like extended cede with hints would be
included and exploited using the cpuidle framework. The statistics and 
tracing infrastructure provided by the cpuidle framework also helps in 
enabling power management related tools and help tune the system and 
applications.

This series aims to maintain compatibility and functionality to
existing pSeries idle cpu management code.  There are no new functions
or idle states added as part of this series.

The previous version of this patch can be found at
https://lkml.org/lkml/2011/6/7/375

Changes from the previous version (v1):

	1] Rebased to latest 3.2-rc2

	2] Incorporated the changes from the feedback provided by Ben
	   in the previous version of this series.

	3] The first three patches in this series posted in v1 are not
	   re-posted as they were taken from "idle cleanup - v3" posted by
	   Len Brown (https://lkml.org/lkml/2011/4/2/8) which have made 
	   to the mainline in 3.1. 
	   This cleanup was a community requirement and major dependency
	   before cpuidle framework can be ported over to powerpc
	   architecture.

This patch series includes:

[1/4] - Provides arch specific cpu_idle_wait() function required by cpuidle
  subsystem.
[2/4] - pseries_idle cpuidle driver
[3/4] - Enables cpuidle for pSeries and directly calls cpuidle_idle_call()
[4/4] - Handles powersave=off kernel boot parameter and disables registration
  of pseries_idle cpuidle driver.

This series has been tested on ppc64 pSeries POWER7 system with the snooze
and cede states

--
 arch/powerpc/Kconfig                            |    4 
 arch/powerpc/include/asm/processor.h            |    3 
 arch/powerpc/include/asm/system.h               |    9 +
 arch/powerpc/kernel/idle.c                      |   26 ++
 arch/powerpc/kernel/sysfs.c                     |    2 
 arch/powerpc/platforms/Kconfig                  |    6 
 arch/powerpc/platforms/pseries/Kconfig          |    9 +
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  321 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h        |    3 
 arch/powerpc/platforms/pseries/setup.c          |   89 ------
 arch/powerpc/platforms/pseries/smp.c            |    1 
 include/linux/cpuidle.h                         |    2 
 13 files changed, 387 insertions(+), 89 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/processor_idle.c



-Deepthi 

