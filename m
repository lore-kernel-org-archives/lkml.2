Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0HJKFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:05:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:36905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab0HJKFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,347,1278313200"; 
   d="scan'208";a="310174791"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] intel mid battery: Fix battery scaling
To: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Aug 2010 10:28:04 +0100
Message-ID: <20100810092804.1814.66442.stgit@localhost.localdomain>
In-Reply-To: <20100810092700.1814.11982.stgit@localhost.localdomain>
References: <20100810092700.1814.11982.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3600 seconds per not 3600 hours per second. Correcting this
along with the previous fix gives sensible numbers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/intel_mid_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 6430a7b..c61ffec 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -427,7 +427,7 @@ static int pmic_usb_get_property(struct power_supply *psy,
 static inline unsigned long mAStouAh(unsigned long v)
 {
 	/* seconds to hours, mA to µA */
-	return v * 3600 * 1000;
+	return (v * 1000) / 3600;
 }
 
 /**

