Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3ADTNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:13:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:32520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab3ADTNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:13:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,412,1355126400"; 
   d="scan'208";a="267479567"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Joe Perches <joe@perches.com>,
        Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v6 0/3] PM: Intel PowerClamp driver
Date: Fri,  4 Jan 2013 03:12:42 -0800
Message-Id: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v6 changes:
- clamp module parameters duration and window size, reword warning
  messages when input parameters are out of range.

We have done some experiment with idle injection on Intel platforms.
The idea is to use the increasingly power efficient package level
C-states for power capping and passive thermal control.

Documentation is included in the patch to explain the theory of
operation, performance implication, calibration, scalability, and user
interface. Please refer to the following file for more details.

Documentation/thermal/intel_powerclamp.txt

Arjan van de Ven created the original idea and driver, I have been
refining driver in hope that they can be to be useful beyond a proof
of concept.

Jacob Pan (3):
  tick: export nohz tick idle symbols for module use
  x86/nmi: export local_touch_nmi() symbol for modules
  PM: Introduce Intel PowerClamp Driver

 Documentation/thermal/intel_powerclamp.txt |  307 +++++++++++
 arch/x86/kernel/nmi.c                      |    1 +
 drivers/thermal/Kconfig                    |   10 +
 drivers/thermal/Makefile                   |    2 +
 drivers/thermal/intel_powerclamp.c         |  788 ++++++++++++++++++++++++++++
 kernel/time/tick-sched.c                   |    2 +
 6 files changed, 1110 insertions(+)
 create mode 100644 Documentation/thermal/intel_powerclamp.txt
 create mode 100644 drivers/thermal/intel_powerclamp.c

-- 
1.7.9.5

