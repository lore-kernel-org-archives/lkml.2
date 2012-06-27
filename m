Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2F0T1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:27:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59766 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2F0T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:12 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 9/9] staging: line6: Changed strict_strtoul() to kstrtou8() in pod_set_midi_postprocess()
Date: Wed, 27 Jun 2012 21:26:03 +0200
Message-Id: <1340825163-32568-10-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a call to strict_strtoul() into kstrtou8() in
pod_set_midi_postprocess().

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pod.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 2a85ec3..9edd053 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -892,10 +892,10 @@ static ssize_t pod_set_midi_postprocess(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	unsigned long value;
+	u8 value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtou8(buf, 10, &value);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6

