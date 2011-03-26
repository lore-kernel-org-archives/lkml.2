Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1CZSUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:20:35 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:41537 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1CZSUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:20:34 -0400
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] [media] cpia2: fix typo in variable initialisation
Date: Sat, 26 Mar 2011 19:20:24 +0100
Message-Id: <1301163624-7362-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently 'fh' initialises to whatever happens to be on stack. This
looks like a typo and this patch fixes that.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/media/video/cpia2/cpia2_v4l.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 5111bbc..0073a8c 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1313,7 +1313,7 @@ static int cpia2_g_priority(struct file *file, void *_fh, enum v4l2_priority *p)
 static int cpia2_s_priority(struct file *file, void *_fh, enum v4l2_priority prio)
 {
 	struct camera_data *cam = video_drvdata(file);
-	struct cpia2_fh *fh = fh;
+	struct cpia2_fh *fh = _fh;
 
 	if (cam->streaming && prio != fh->prio &&
 			fh->prio == V4L2_PRIORITY_RECORD)
-- 
1.7.0.4

