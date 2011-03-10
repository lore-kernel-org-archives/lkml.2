Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1CJCoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:44:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1CJCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oH+Pa+9hMFgTVW83vPhrCk+UGaf85Z6D6nZhvngZIWdDcapNAzgipg7qSi/0Kt4BVX
         ufaym8enV7VuQt7nbDY0ABfg3ygqTHmTBB4tb365mcMbfrtVYsnkEAsiWVuyTRaHGgO5
         GuSV03lVvp4+sXpM02Rpcla+47ewVS3AfcaM8=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 5/6] staging: hv: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:07 +0300
Message-Id: <1299724988-25351-5-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/hv/hv_mouse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 8f94f43..954164c 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -688,6 +688,7 @@ static int MousevscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 
 	if (ret != 0) {
 		pr_err("unable to open channel: %d", ret);
+		FreeInputDevice(inputDevice);
 		return -1;
 	}
 
@@ -699,6 +700,7 @@ static int MousevscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 		pr_err("unable to connect channel: %d", ret);
 
 		vmbus_close(Device->channel);
+		FreeInputDevice(inputDevice);
 		return ret;
 	}
 
-- 
1.7.4.1

