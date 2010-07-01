Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab0GAWAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:00:06 -0400
Received: from kroah.org ([198.145.64.141]:33852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883Ab0GAVNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.039970545@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kamal Mostafa <kamal@canonical.com>, Zhang Rui <rui.zhang@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jiri Kosina <jkosina@suse.cz>,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: [031/200] ACPI: video: fix acpi_backlight=video
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit eeb4bcb4771679d7b3446c0293334faee11b090a upstream.

Make "acpi_backlight=video" param enable ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO
as intended, instead of incorrectly enabling video output switching.

BugLink: http://bugs.launchpad.net/bugs/573120

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Acked-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video_detect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -250,7 +250,7 @@ static int __init acpi_backlight(char *s
 				ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
 		if (!strcmp("video", str))
 			acpi_video_support |=
-				ACPI_VIDEO_OUTPUT_SWITCHING_FORCE_VIDEO;
+				ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO;
 	}
 	return 1;
 }


