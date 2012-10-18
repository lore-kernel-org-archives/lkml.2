Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2JRLMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:47813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2JRLMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020406"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 0/7] power_supply: Introduce charging Framework
Date: Thu, 18 Oct 2012 22:13:59 +0530
Message-Id: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Supply charging framework connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
extcon, and thermal. With this the charging is handled in a generic way.

The framework makes use of different new features - Battery Identification
framework, pluggable charging algorithms, charger cable arbitrations.
PSE compliant charging algorithm also enabled as part of this patchset.

With this framework the charging logic can be kept outside the charger driver.
The charger driver just need to expose th get_property and set_property functions
to get and set a specific set of power supply properties. The driver can
convert these values to the hardware configurations to setup charging.


Jenny TC (7):
  power_supply : Introduce battery identification framework
  power_supply: Add charger control properties
  power_supply : add supported charger cable  feature
  power_supply: add throttle state
  power_supply: Introduce Power Supply charging framework
  power_supply: enable charger framework callbacks
  power_supply: Introduce PSE compliant algorithm

 drivers/power/Kconfig                |   28 ++
 drivers/power/Makefile               |    3 +
 drivers/power/battery_id.c           |   94 +++++
 drivers/power/charging_algo_pse.c    |   79 +++++
 drivers/power/power_supply.h         |   20 ++
 drivers/power/power_supply_charger.c |  634 ++++++++++++++++++++++++++++++++++
 drivers/power/power_supply_charger.h |  165 +++++++++
 drivers/power/power_supply_core.c    |   12 +
 drivers/power/power_supply_sysfs.c   |   16 +-
 include/linux/power/battery_id.h     |   97 ++++++
 include/linux/power_supply.h         |   53 ++-
 11 files changed, 1189 insertions(+), 12 deletions(-)
 create mode 100644 drivers/power/battery_id.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/battery_id.h

-- 
1.7.9.5

