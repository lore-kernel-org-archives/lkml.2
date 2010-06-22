Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0FVLlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:41:51 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:35810 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0FVLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:41:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jiri Slaby <jslaby@suse.cz>, Andy Walls <awalls@md.metrocast.net>,
       Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
Date: Tue, 22 Jun 2010 13:41:50 +0200
Message-Id: <1277206910-27228-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that in ivtvfb_callback_cleanup there is an unneeded test
for itv being NULL. But itv is initialized as container_of with
non-zero offset, so it is never NULL (even if v4l2_dev is). This was
found because itv is dereferenced earlier than the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ian Armstrong <ian@iarmst.demon.co.uk>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/ivtv/ivtvfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index 9ff3425..5dc460e 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1219,7 +1219,7 @@ static int ivtvfb_callback_cleanup(struct device *dev, void *p)
 	struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
 	struct osd_info *oi = itv->osd_info;
 
-	if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
 		if (unregister_framebuffer(&itv->osd_info->ivtvfb_info)) {
 			IVTVFB_WARN("Framebuffer %d is in use, cannot unload\n",
 				       itv->instance);
-- 
1.7.1


