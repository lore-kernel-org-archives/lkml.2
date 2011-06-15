Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1FOBJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:09:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46884 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1FOBJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=YSni8rfkIaW0nUfdxbzKvVO19DeQCCIoq8Ho+bEzqHOat0U4IwEpbLXTVFnj4qt+iE
         +2rjWkwEZ8KJ85yOKbBDIWEWYU6MhnqTwpJCJucE7r4ToESNb27EIz+cjgnMvsFLtaFl
         V/QNoPcpE39II6i+ObQ5Ay7Nuxkmm1BcvHPww=
Subject: re:Possible deadlock when suspending framebuffer
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-rTnFNydmgaih3M/h0Rn4"
Date: Wed, 15 Jun 2011 09:09:24 +0800
Message-ID: <1308100165.2113.4.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rTnFNydmgaih3M/h0Rn4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

<snip>
Hi Francis:
can you test this patch?
Thanks

>From fe026c42af4cbdce053460a428a445e99071586a Mon Sep 17 00:00:00 2001
From: Wanlong Gao <wanlong.gao@gmail.com>
Date: Wed, 15 Jun 2011 09:03:41 +0800
Subject: [PATCH] test



Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/video/fbmem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 5aac00e..6e6cef3 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1642,11 +1642,8 @@ static int do_unregister_framebuffer(struct
fb_info *fb_info)
 	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
 		return -EINVAL;
 
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
-	unlock_fb_info(fb_info);
 
 	if (ret)
 		return -EINVAL;
-- 
1.7.4.1



--=-rTnFNydmgaih3M/h0Rn4
Content-Disposition: attachment; filename="0001-test.patch"
Content-Type: text/x-patch; name="0001-test.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From fe026c42af4cbdce053460a428a445e99071586a Mon Sep 17 00:00:00 2001
From: Wanlong Gao <wanlong.gao@gmail.com>
Date: Wed, 15 Jun 2011 09:03:41 +0800
Subject: [PATCH] test

test

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/video/fbmem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 5aac00e..6e6cef3 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1642,11 +1642,8 @@ static int do_unregister_framebuffer(struct fb_info *fb_info)
 	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
 		return -EINVAL;
 
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
-	unlock_fb_info(fb_info);
 
 	if (ret)
 		return -EINVAL;
-- 
1.7.4.1


--=-rTnFNydmgaih3M/h0Rn4--

