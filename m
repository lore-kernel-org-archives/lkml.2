Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab1CYXw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:56 -0400
Received: from kroah.org ([198.145.64.141]:41767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1CYXws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:11 2011
Message-Id: <20110325234511.625750905@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [36/63] [media] uvcvideo: Fix descriptor parsing for video output devices
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 4093a5c4a3f59cba1a085bbf87b6ffdddc5a443d upstream.

Commit 4057ac6ca9a77c4275b34b5925ab5c99557913b1

    V4L/DVB (13505): uvcvideo: Refactor chain scan

broke output terminals parsing. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1264,6 +1264,14 @@ static int uvc_scan_chain_entity(struct
 
 		break;
 
+	case UVC_OTT_VENDOR_SPECIFIC:
+	case UVC_OTT_DISPLAY:
+	case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" OT %d", entity->id);
+
+		break;
+
 	case UVC_TT_STREAMING:
 		if (UVC_ENTITY_IS_ITERM(entity)) {
 			if (uvc_trace_param & UVC_TRACE_PROBE)


