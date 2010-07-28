Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab0G1TJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:09:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:9181 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0G1TJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="305514017"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Huaxu Wan" <huaxu.wan@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATH V2 0/5] Package Level Thermal Control and Power Limit Notification
Date: Wed, 28 Jul 2010 12:00:48 -0700
Message-Id: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |  209 +++++++++++---
 drivers/hwmon/Kconfig                      |    7 +
 drivers/hwmon/Makefile                     |    1 +
 drivers/hwmon/pkgtemp.c                    |  456 ++++++++++++++++++++++++++++
 10 files changed, 691 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/hwmon/pkgtemp
 create mode 100644 drivers/hwmon/pkgtemp.c

-- 
1.7.2

