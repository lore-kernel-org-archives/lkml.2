Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1LaIvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 03:51:03 -0500
Received: from home.keithp.com ([63.227.221.253]:34472 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1LaIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 03:51:00 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, Bdale Garbee <bdale@gag.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] acpi/video: Don't restore backlight to 0 at boot time
Date: Sat, 31 Dec 2011 00:52:27 -0800
Message-Id: <1325321547-20637-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the initial ACPI reported backlight level is zero, or larger than
max_level, then ignore it and set the level back to the current level
instead. This avoids ending up with a black screen on an HP Pavilion
G series G4 notebook QE040UA#ABA.

Reported-by: Bdale Garbee <bdale@gag.com>
Cc: Bdale Garbee <bdale@gag.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/acpi/video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 08a44b5..688f342 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -711,7 +711,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 		 * when invoked for the first time, i.e. level_old is invalid.
 		 * set the backlight to max_level in this case
 		 */
-		if (use_bios_initial_backlight) {
+		if (use_bios_initial_backlight && 0 < level_old && level_old <= max_level) {
 			for (i = 2; i < br->count; i++)
 				if (level_old == br->levels[i])
 					level = level_old;
-- 
1.7.7.3

