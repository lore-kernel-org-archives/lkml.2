Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2E0BMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:12:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab2E0BL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:57 -0400
Message-Id: <20120527010434.337572976@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jozef Vesely <vesely@gjh.sk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 75/94] media: uvcvideo: Fix ENUMINPUT handling
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 31c5f0c5e25ed71eeced170f113bb590f2f1f6f3 upstream.

Properly validate the user-supplied index against the number of inputs.
The code used the pin local variable instead of the index by mistake.

Reported-by: Jozef Vesely <vesely@gjh.sk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -686,7 +686,7 @@ static long uvc_v4l2_do_ioctl(struct fil
 					break;
 			}
 			pin = iterm->id;
-		} else if (pin < selector->bNrInPins) {
+		} else if (index < selector->bNrInPins) {
 			pin = selector->baSourceID[index];
 			list_for_each_entry(iterm, &chain->entities, chain) {
 				if (!UVC_ENTITY_IS_ITERM(iterm))


