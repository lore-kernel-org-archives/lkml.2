Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0HWU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0HWU0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:26:23 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org,
        lenb@kernel.org, Matthew Garrett <mjg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] ACPI: Don't report current_now if battery reports in mWh
Date: Mon, 23 Aug 2010 16:25:32 -0400
Message-Id: <1282595132-5026-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI batteries can report in units of either current or energy. Right
now we expose the current_now file even if the battery is reporting
energy units, resulting in a file that should contain mA instead
containing mW. Don't expose this value unless the battery is reporting
current.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/acpi/battery.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index dc58402..9841720 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -273,7 +273,6 @@ static enum power_supply_property energy_battery_props[] = {
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_POWER_NOW,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
-- 
1.7.2.1

