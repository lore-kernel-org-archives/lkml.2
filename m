Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031763Ab2CIUE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:04:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36093 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2CITwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:43 -0500
Message-Id: <20120309190217.627950776@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 33/68] [SCSI] osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 41f8ad76362e7aefe3a03949c43e23102dae6e0b upstream.

It used to be that minors where 8 bit. But now they
are actually 20 bit. So the fix is simplicity itself.

I've tested with 300 devices and all user-mode utils
work just fine. I have also mechanically added 10,000
to the ida (so devices are /dev/osd10000, /dev/osd10001 ...)
and was able to mkfs an exofs filesystem and access osds
from user-mode.

All the open-osd user-mode code uses the same library
to access devices through their symbolic names in
/dev/osdX so I'd say it's pretty safe. (Well tested)

This patch is very important because some of the systems
that will be deploying the 3.2 pnfs-objects code are larger
than 64 OSDs and will stop to work properly when reaching
that number.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/osd/osd_uld.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -69,10 +69,10 @@
 #ifndef SCSI_OSD_MAJOR
 #  define SCSI_OSD_MAJOR 260
 #endif
-#define SCSI_OSD_MAX_MINOR 64
+#define SCSI_OSD_MAX_MINOR MINORMASK
 
 static const char osd_name[] = "osd";
-static const char *osd_version_string = "open-osd 0.2.0";
+static const char *osd_version_string = "open-osd 0.2.1";
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
 MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");


