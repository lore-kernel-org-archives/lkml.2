Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPG5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38824 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2KPG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:01 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH 01/14] [media] ivtv: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:33 +0530
Message-Id: <1353048646-10935-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: ivtv-devel@ivtvdriver.org
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 949ae23..4b47b5c 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -993,7 +993,7 @@ int ivtv_s_input(struct file *file, void *fh, unsigned int inp)
 	v4l2_std_id std;
 	int i;
 
-	if (inp < 0 || inp >= itv->nof_inputs)
+	if (inp >= itv->nof_inputs)
 		return -EINVAL;
 
 	if (inp == itv->active_input) {
-- 
1.7.4.1

