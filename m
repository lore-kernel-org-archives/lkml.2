Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1CGKff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:35:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49788 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1CGKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:35:32 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: stable@kernel.org
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [stable-37] ideapad: read brightness setting when have brightness key notify
Date: Mon,  7 Mar 2011 18:35:25 +0800
Message-Id: <1299494125-9655-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922

On ideapad Y530, the brightness key notify will be blocked if the last notify
is not responsed by getting the brightness value. Read value when we get the
notify shall fix the problem and will not have any difference on other ideapads.

This patch is made against 2.6.37.y and this bug impacts kernel after 2.6.37.

The equivalent-fix patch is not in upstream yet. Since the policy of stable tree
is changed and .38 kernel is going to finalize. I think to post this patch for
stable kernel now should be a good idea.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 5ff1220..e78398d 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -357,6 +357,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 		if (test_bit(vpc_bit, &vpc1)) {
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
+			else if (vpc_bit == 4)
+				read_ec_data(handle, 0x12, &vpc2);
 		}
 	}
 }
-- 
1.7.4.1

