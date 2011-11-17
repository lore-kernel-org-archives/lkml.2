Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1KRJeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:34:06 -0500
Received: from www17.your-server.de ([213.133.104.17]:34742 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab1KRJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:32:44 -0500
Subject: [PATCH] [media] pwc: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.285.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
--- a/drivers/media/video/pwc/pwc-ctrl.c 2011-11-07 19:37:51.143333699 +0100
+++ b/drivers/media/video/pwc/pwc-ctrl.c 2011-11-08 10:47:00.679677247 +0100
@@ -113,10 +113,9 @@ static int _send_control_msg(struct pwc_
 	void *kbuf = NULL;
 
 	if (buflen) {
-		kbuf = kmalloc(buflen, GFP_KERNEL); /* not allowed on stack */
+		kbuf = kmemdup(buf, buflen, GFP_KERNEL); /* not allowed on stack */
 		if (kbuf == NULL)
 			return -ENOMEM;
-		memcpy(kbuf, buf, buflen);
 	}
 
 	rc = usb_control_msg(pdev->udev, usb_sndctrlpipe(pdev->udev, 0),
