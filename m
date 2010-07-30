Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0G3AWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:22:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:20012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0G3AWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,283,1278313200"; 
   d="scan'208";a="591131105"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Huaxu Wan" <huaxu.wan@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH V3 0/5] Package Level Thermal Control and Power Limit Notification
Date: Thu, 29 Jul 2010 17:13:41 -0700
Message-Id: <1280448826-12004-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

The new MSRs PACKAGE_THERM_STATUS and PACKAGE_THERM_INTERRUPT and power limit
notification are published in Intel 64 and IA32 SDM and first implemented on
Intel Sandy Bridge platform. The following patch set supports the new features
in Linux kernel. 

Fenghua Yu (5):
  Package Level Thermal Control and Power Limit Notification: enable
    features
  Package Level Thermal Control and Power Limit Notification: pkgtemp
    hwmon driver
  Package Level Thermal Control and Power Limit Notification: thermal
    throttling handler
  Package Level Thermal Control and Power Limit Notification: power
    limit
  Package Level Thermal Control and Power Limit Notification: pkgtemp
    doc

 Documentation/hwmon/pkgtemp                |   36 +++
 arch/x86/configs/i386_defconfig            |    1 +
 arch/x86/configs/x86_64_defconfig          |    1 +
 arch/x86/include/asm/cpufeature.h          |    2 +
 arch/x86/include/asm/msr-index.h           |   17 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |  206 ++++++++++---
 drivers/hwmon/Kconfig                      |    7 +
 drivers/hwmon/Makefile                     |    1 +
 drivers/hwmon/pkgtemp.c                    |  456 ++++++++++++++++++++++++++++
 10 files changed, 688 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/hwmon/pkgtemp
 create mode 100644 drivers/hwmon/pkgtemp.c

