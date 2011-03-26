Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab1CZAGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:06:41 -0400
Received: from kroah.org ([198.145.64.141]:35924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414Ab1CZAGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:58 2011
Message-Id: <20110326000458.451557082@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [25/35] [media] uvcvideo: Fix descriptor parsing for video output devices
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1260,6 +1260,14 @@ static int uvc_scan_chain_entity(struct
 
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


