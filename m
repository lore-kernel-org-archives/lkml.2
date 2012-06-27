Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2F0T21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:28:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab2F0T1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:10 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 7/9] staging: line6: Exchanged strict_strtoul with kstrtou8() in pod.c:pod_resolve()
Date: Wed, 27 Jun 2012 21:26:01 +0200
Message-Id: <1340825163-32568-8-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exchanged call to strict_strtoul() with kstrtou8() in pod_resolve().

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pod.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 459f325..4c81914 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -434,11 +434,11 @@ void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
 static int pod_resolve(const char *buf, short block0, short block1,
 		       unsigned char *location)
 {
-	unsigned long value;
+	u8 value;
 	short block;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtou8(buf, 10, &value);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6

