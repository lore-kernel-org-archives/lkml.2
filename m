Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab2KPG5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KPG5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:10 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 04/14] [media] tlg2300: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:36 +0530
Message-Id: <1353048646-10935-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/usb/tlg2300/pd-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 1f448ac..dd157e7 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -923,7 +923,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 	struct poseidon *pd = front->pd;
 	s32 ret, cmd_status;
 
-	if (i < 0 || i >= POSEIDON_INPUTS)
+	if (i >= POSEIDON_INPUTS)
 		return -EINVAL;
 	ret = send_set_req(pd, SGNL_SRC_SEL,
 			pd_inputs[i].tlg_src, &cmd_status);
-- 
1.7.4.1

