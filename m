Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1JVFtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1JVFtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:32 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/36] Staging: cx25821: cx25821-video.c: Fix assignment
Date: Sat, 22 Oct 2011 13:43:51 +0800
Message-Id: <1319262236-6498-32-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change double assignment in one statement into two assignment
statements.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 268fe19..b07c3a8 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1622,7 +1622,8 @@ int cx25821_vidioc_cropcap(struct file *file, void *priv,
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	cropcap->bounds.top = cropcap->bounds.left = 0;
+	cropcap->bounds.top = 0;
+	cropcap->bounds.left = 0;
 	cropcap->bounds.width = 720;
 	cropcap->bounds.height = dev->tvnorm == V4L2_STD_PAL_BG ? 576 : 480;
 	cropcap->pixelaspect.numerator =
-- 
1.7.0.4

