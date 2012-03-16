Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946304Ab2CPXsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:48:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946268Ab2CPXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:21 -0400
Message-Id: <20120316233811.223052904@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gary Thomas <gary@mlbassoc.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 07/41] [media] omap3isp: ccdc: Fix crash in HS/VS interrupt handler
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit bd0f2e6da7ea9e225cb2dbd3229e25584b0e9538 upstream.

The HS/VS interrupt handler needs to access the pipeline object. It
erronously tries to get it from the CCDC output video node, which isn't
necessarily included in the pipeline. This leads to a NULL pointer
dereference.

Fix the bug by getting the pipeline object from the CCDC subdev entity.

Reported-by: Gary Thomas <gary@mlbassoc.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/omap3isp/ispccdc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1406,8 +1406,7 @@ static int __ccdc_handle_stopping(struct
 
 static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
-	struct isp_pipeline *pipe =
-		to_isp_pipeline(&ccdc->video_out.video.entity);
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct video_device *vdev = ccdc->subdev.devnode;
 	struct v4l2_event event;
 


