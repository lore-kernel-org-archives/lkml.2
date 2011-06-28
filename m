Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1F1NiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:38:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab1F1NgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:36:17 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ike.pan@canonical.com, vanhoof@canonical.com, kent.lin@canonical.com,
        sylee@canonical.com, Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH 1/2] ideapad-laptop: Ignore an unused VPC notification
Date: Tue, 28 Jun 2011 14:35:53 +0100
Message-Id: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIOS fires notifications in a constant period with VPC bit 1 set when the
power cord is unplugged.

This event is not known yet to have any effect, but it makes the
call to sparse_keymap_report_event() and generates many KEY_UNKNOWNs.

This causes the userspace (Gnome Power Manager in my case) unable
to enter the idle mode. As the result there is no screensaver showing up,
no dim backlight, etc.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index bfdda33..820f013 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -463,7 +463,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 				ideapad_sync_rfk_state(adevice);
 			else if (vpc_bit == 4)
 				read_ec_data(handle, 0x12, &vpc2);
-			else
+			else if (vpc_bit == 1) {
+			} else
 				ideapad_input_report(priv, vpc_bit);
 		}
 	}
-- 
1.7.4.1

