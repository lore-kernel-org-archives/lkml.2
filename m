Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1CVMcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:32:25 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47158 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1CVMcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:32:23 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 0/5] cpuidle: Cleanup pm_idle and include
	driver/cpuidle.c in-kernel 
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Tue, 22 Mar 2011 18:02:18 +0530
Message-ID: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V4:
* Implemented cpuidle driver for xen. Earlier pm_idle
  function pointer would be set to default idle. Now a cpuidle_driver
  encapsulating the idle routine is cleanly registered for this 
  using cpuidle_register_driver API.

* Implemented a cpuidle driver for apm_cpu_idle() as part of
  APM BIOS driver. Earlier APM BIOS driver would flip 
  pm_idle function pointer to apm_cpu_idle.

* This patch series applies on 2.6.38, and was tested on x86 system 
  with multiple sleep states.

Goal:
This patch series tries to achieve the goal of having cpuidle manage
all idle routine for x86. It removes pm_idle function pointer which
causes problems discussed at http://lkml.org/lkml/2009/8/28/43 and
http://lkml.org/lkml/2009/8/28/50.

V1 of this series is at https://lkml.org/lkml/2010/10/19/449,
V2 is at https://lkml.org/lkml/2011/1/13/98 and 
V3 is at https://lkml.org/lkml/2011/2/8/73

---

Trinabh Gupta (5):
      cpuidle: cpuidle driver for apm
      cpuidle: driver for xen
      cpuidle: default idle driver for x86
      cpuidle: list based cpuidle driver registration and selection
      cpuidle: Remove pm_idle pointer for x86


 arch/x86/Kconfig              |    2
 arch/x86/kernel/apm_32.c      |   75 ++++++-
 arch/x86/kernel/process.c     |  339 --------------------------------
 arch/x86/kernel/process_32.c  |    4
 arch/x86/kernel/process_64.c  |    4
 arch/x86/xen/setup.c          |   42 ++++
 drivers/acpi/processor_idle.c |    2
 drivers/cpuidle/Kconfig       |    9 +
 drivers/cpuidle/cpuidle.c     |   50 ++++-
 drivers/cpuidle/driver.c      |  114 ++++++++++-
 drivers/idle/Makefile         |    1
 drivers/idle/default_driver.c |  437 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h       |    3
 13 files changed, 707 insertions(+), 375 deletions(-)
 create mode 100644 drivers/idle/default_driver.c

--
-Trinabh
