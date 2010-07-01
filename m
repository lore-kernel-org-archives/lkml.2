Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab0GAWUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:20:42 -0400
Received: from kroah.org ([198.145.64.141]:47184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab0GAUti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.642134576@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kamal Mostafa <kamal@canonical.com>, Zhang Rui <rui.zhang@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jiri Kosina <jkosina@suse.cz>,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: [patch 021/164] ACPI: video: fix acpi_backlight=video
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

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


