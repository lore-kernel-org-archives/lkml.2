Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1FCFFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:05:05 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:38325 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FCFFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=DwQ9JxUX1HUhJuHURCPlCtAz+lBAO4chYLgGHtUiAemRgZLSHzwH2ATp/4agfpPMmx
         pqvds3Z7cri0SoGhMhkOmgh1gDVKSGopIehaBRiqJQVmU5qSl46R9kqRajG52xpy4pCZ
         1V1KKjGZGVzVhnawbKuoiUxktp0eeozkrtPz4=
From: Eric Miao <eric.miao@linaro.org>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.miao@linaro.org>
Subject: [PATCH] brd: make brd_make_request() return error code
Date: Fri,  3 Jun 2011 13:02:47 +0800
Message-Id: <1307077367-6277-1-git-send-email-eric.miao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

brd_make_request() always returns 0, which doesn't make much sense.

Signed-off-by: Eric Miao <eric.miao@linaro.org>
---
 drivers/block/brd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index dba1c32..a9587ee 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -360,7 +360,7 @@ static int brd_make_request(struct request_queue *q, struct bio *bio)
 out:
 	bio_endio(bio, err);
 
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_BLK_DEV_XIP
-- 
1.7.4.1

