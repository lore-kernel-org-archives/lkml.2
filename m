Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2KMGEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:04:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:47982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2KMGET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:04:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="241143522"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/3] pm: Intel powerclamp driver 
Date: Mon, 12 Nov 2012 14:03:48 -0800
Message-Id: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
 drivers/thermal/Makefile                   |    1 +
 drivers/thermal/intel_powerclamp.c         |  766 ++++++++++++++++++++++++++++
 kernel/time/tick-sched.c                   |    2 +
 6 files changed, 1087 insertions(+)
 create mode 100644 Documentation/thermal/intel_powerclamp.txt
 create mode 100644 drivers/thermal/intel_powerclamp.c

-- 
1.7.9.5

