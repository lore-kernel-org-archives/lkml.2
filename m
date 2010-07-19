Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab0GSRjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:39:52 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:47423 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760783Ab0GSRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:39:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: awalls@md.metrocast.net, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        Ian Armstrong <ian@iarmst.demon.co.uk>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org
Subject: [PATCH 1/1] VIDEO: ivtvfb, remove unneeded NULL test
Date: Mon, 19 Jul 2010 19:39:34 +0200
Message-Id: <1279561174-12468-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278346795.2229.2.camel@localhost>
References: <1278346795.2229.2.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that in ivtvfb_callback_cleanup and ivtvfb_callback_init
there are unneeded tests for itv being NULL. But itv is initialized
as container_of with non-zero offset in those functions, so it is
never NULL (even if v4l2_dev is). This was found because itv is
dereferenced earlier than the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ian Armstrong <ian@iarmst.demon.co.uk>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/ivtv/ivtvfb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index 9ff3425..9c77bfa 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1203,7 +1203,7 @@ static int __init ivtvfb_callback_init(struct device *dev, void *p)
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
 	struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
 
-	if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
+	if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
 		if (ivtvfb_init_card(itv) == 0) {
 			IVTVFB_INFO("Framebuffer registered on %s\n",
 					itv->v4l2_dev.name);
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


