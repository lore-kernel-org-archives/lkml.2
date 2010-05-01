Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0EATKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 15:10:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39427 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0EATKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 15:10:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>, Len Brown <lenb@kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jiri Kosina <jkosina@suse.cz>, <stable@kernel.org>
Subject: [PATCH] acpi: video: fix acpi_backlight=video
Date: Sat,  1 May 2010 12:09:49 -0700
Message-Id: <1272740989-4027-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make "acpi_backlight=video" param enable ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO
as intended, instead of incorrectly enabling video output switching.

BugLink: http://bugs.launchpad.net/bugs/573120

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: <stable@kernel.org>
---
 drivers/acpi/video_detect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index fc2f26b..c5fef01 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -250,7 +250,7 @@ static int __init acpi_backlight(char *str)
 				ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
 		if (!strcmp("video", str))
 			acpi_video_support |=
-				ACPI_VIDEO_OUTPUT_SWITCHING_FORCE_VIDEO;
+				ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO;
 	}
 	return 1;
 }
-- 
1.7.0.4

