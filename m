Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2F3FII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:08:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50180 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2F3FIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:08:04 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Igor Murzov <intergalactic.anonymous@gmail.com>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 7/8] ACPI video: Still use ACPI backlight control if _DOS doesn't exist
Date: Sat, 30 Jun 2012 01:07:34 -0400
Message-Id: <b03738430c7537d5f87948e0b35d8aaf2688c6b4.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
References: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

This fixes a regression in 3.4-rc1 caused by commit
ea9f8856bd6d4ed45885b06a338f7362cd6c60e5
(ACPI video: Harden video bus adding.)

Some platforms don't have _DOS control method, but the ACPI
backlight still works.
We should not invoke _DOS for these platforms.

https://bugzilla.kernel.org/show_bug.cgi?id=43168

Cc: Igor Murzov <intergalactic.anonymous@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 9577b6f..4134b30 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -558,6 +558,8 @@ acpi_video_bus_DOS(struct acpi_video_bus *video, int bios_flag, int lcd_flag)
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
 
+	if (!video->cap._DOS)
+		return 0;
 
 	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1)
 		return -EINVAL;
-- 
1.7.11.1.104.ge7b44f1

