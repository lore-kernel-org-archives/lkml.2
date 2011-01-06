Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1AFWoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:44:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1AFWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:44:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/11] ACPI / PM: Report wakeup events from buttons
Date: Thu, 6 Jan 2011 23:36:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201101062331.17079.rjw@sisk.pl>
In-Reply-To: <201101062331.17079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062336.01492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since ACPI buttons and lids can be configured to wake up the system
from sleep states, report wakeup events from these devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/button.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -279,6 +279,9 @@ static int acpi_lid_send_state(struct ac
 	input_report_switch(button->input, SW_LID, !state);
 	input_sync(button->input);
 
+	if (state)
+		pm_wakeup_event(&device->dev, 0);
+
 	ret = blocking_notifier_call_chain(&acpi_lid_notifier, state, device);
 	if (ret == NOTIFY_DONE)
 		ret = blocking_notifier_call_chain(&acpi_lid_notifier, state,
@@ -314,6 +317,8 @@ static void acpi_button_notify(struct ac
 			input_sync(input);
 			input_report_key(input, keycode, 0);
 			input_sync(input);
+
+			pm_wakeup_event(&device->dev, 0);
 		}
 
 		acpi_bus_generate_proc_event(device, event, ++button->pushed);

