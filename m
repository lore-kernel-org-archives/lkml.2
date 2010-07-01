Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab0GAVTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:24 -0400
Received: from kroah.org ([198.145.64.141]:33207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131Ab0GAVPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:14 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.482848572@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [177/200] V4L/DVB: uvcvideo: Prevent division by 0 when control step value is 0
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit cf7a50eeb6f462a0b7d1619fcb27a727a2981769 upstream.

The control step values reported by the device are used as a divisor
unchecked, which can result in a division by zero.

Check the step value and make it 1 when null.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1047,6 +1047,8 @@ int uvc_ctrl_set(struct uvc_video_chain
 				   uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
 		step = mapping->get(mapping, UVC_GET_RES,
 				    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+		if (step == 0)
+			step = 1;
 
 		xctrl->value = min + (xctrl->value - min + step/2) / step * step;
 		xctrl->value = clamp(xctrl->value, min, max);


