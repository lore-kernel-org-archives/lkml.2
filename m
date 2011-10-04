Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1JDTdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:33:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab1JDTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:33:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Joey Lee <jlee@novell.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acer-wmi: Add wireless quirk for Lenovo 3000 N200
Date: Tue,  4 Oct 2011 14:32:58 -0500
Message-Id: <1317756778-11822-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quirk fixes the wlan rfkill status on this machine. Without
it, wlan is permanently soft blocked whenever acer-wmi is loaded.

BugLink: https://bugs.launchpad.net/bugs/865807
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/acer-wmi.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index af2bb20..dac286a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -464,6 +464,15 @@ static struct dmi_system_id acer_quirks[] = {
 		},
 		.driver_data = &quirk_lenovo_ideapad_s205,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Lenovo 3000 N200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "0687A31"),
+		},
+		.driver_data = &quirk_fujitsu_amilo_li_1718,
+	},
 	{}
 };
 
-- 
1.7.4.1

