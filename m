Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab1DZVSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:18:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:22884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab1DZVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738832037"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: laurent.pinchart@ideasonboard.com, mchehab@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [97/106] uvcvideo: Fix descriptor parsing for video output devices
Message-Id: <20110426211419.BA2903E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 4093a5c4a3f59cba1a085bbf87b6ffdddc5a443d upstream.

Commit 4057ac6ca9a77c4275b34b5925ab5c99557913b1

    V4L/DVB (13505): uvcvideo: Refactor chain scan

broke output terminals parsing. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/uvc/uvc_driver.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/uvc/uvc_driver.c
+++ linux-2.6.35.y/drivers/media/video/uvc/uvc_driver.c
@@ -1261,6 +1261,14 @@ static int uvc_scan_chain_entity(struct 
 
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
