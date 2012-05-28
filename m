Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2E1Dgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124Ab2E1D3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:43 -0400
Message-Id: <20120528031215.428344384@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jozef Vesely <vesely@gjh.sk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 091/117] [media] uvcvideo: Fix ENUMINPUT handling
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 31c5f0c5e25ed71eeced170f113bb590f2f1f6f3 upstream.

Properly validate the user-supplied index against the number of inputs.
The code used the pin local variable instead of the index by mistake.

Reported-by: Jozef Vesely <vesely@gjh.sk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index a3322ed..759bef8 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -694,7 +694,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					break;
 			}
 			pin = iterm->id;
-		} else if (pin < selector->bNrInPins) {
+		} else if (index < selector->bNrInPins) {
 			pin = selector->baSourceID[index];
 			list_for_each_entry(iterm, &chain->entities, chain) {
 				if (!UVC_ENTITY_IS_ITERM(iterm))


