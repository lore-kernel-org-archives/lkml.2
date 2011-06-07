Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1FGQ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:29:21 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53110 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1FGQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:29:20 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 0/7] cpuidle: (POWER) cpuidle driver for pSeries
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jun 2011 21:59:15 +0530
Message-ID: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series ports the cpuidle framework for ppc64 platform and
implements a cpuidle back-end driver for ppc64 (pSeries) platform.
Currently idle states are managed by pseries_{dedicated,shared}_idle_sleep() 
routines in arch/powerpc/platforms/pseries/setup.c.  There are
generally two idle states (snooze and cede) that are exploited by
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
or idle states added as part of this series. The first three patch
in the series are taken from "idle cleanup - v3" posted by 
Len Brown (https://lkml.org/lkml/2011/4/2/8). These are required to
eliminate usage of pm_idle.

[1/7] cpuidle: create bootparam "cpuidle.off=1"
[2/7] cpuidle: replace xen access to x86 pm_idle and default_idle
[3/7] cpuidle: stop using pm_idle
[4/7] - Provides arch specific cpu_idle_wait() function required by cpuidle
  subsystem.
[5/7] - pseries_idle cpuidle driver
[6/7] - Enables cpuidle for pSeries and directly calls cpuidle_idle_call()
[7/7] - Handles powersave=off kernel boot parameter and disables registration
  of pseries_idle cpuidle driver.

This patch series has the following dependencies:

(1) Base kernel tree: 3.0.0-rc2
(2) Patch: cpuidle: global registration patch 
        https://lkml.org/lkml/2011/6/6/259

This series is tested on ppc64 pSeries POWER7 system with the snooze
and cede states.

Thanks,
-Trinabh
