Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1BWNkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:40:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37622 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1BWNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:40:08 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] ideapad: read brightness setting on brightness key notify
Date: Wed, 23 Feb 2011 21:39:59 +0800
Message-Id: <1298468399-3642-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922

On ideapad Y530, the brightness key notify will be blocked if the last notify
is not responsed by getting the brightness value. Read value when we get the
notify shall fix the problem and will not have any difference on other ideapads.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 114d952..21b1018 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -459,6 +459,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 		if (test_bit(vpc_bit, &vpc1)) {
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
+			else if (vpc_bit == 4)
+				read_ec_data(handle, 0x12, &vpc2);
 			else
 				ideapad_input_report(priv, vpc_bit);
 		}
-- 
1.7.4.1

