Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2HFMJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:09:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43499 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2HFMJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:09:05 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        morbidrsa@googlemail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] line6: pcm.c: Changed simple_strtoul to kstrtoint
Date: Mon,  6 Aug 2012 14:08:50 +0200
Message-Id: <1344254930-8214-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed call to simple_strtoul to kstrtoint in pcm_set_impulse_volume(...)

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pcm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 5e319e3..7fe44a6 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -48,7 +48,13 @@ static ssize_t pcm_set_impulse_volume(struct device *dev,
 				      const char *buf, size_t count)
 {
 	struct snd_line6_pcm *line6pcm = dev2pcm(dev);
-	int value = simple_strtoul(buf, NULL, 10);
+	int value;
+	int rv;
+
+	rv = kstrtoint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
+
 	line6pcm->impulse_volume = value;
 
 	if (value > 0)
-- 
1.7.11.2

