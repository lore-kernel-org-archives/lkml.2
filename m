Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab0KWGJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 01:09:07 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62581 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0KWGJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 01:09:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CLluZ3AIqK8HqK4H53bG6iyb28ceLrenbD3rkS9Emx/sKHrtiUIsYNd0tVCGizlw1Q
         S4o0RFAT9xjqQM2my+zJO+kfIIj5yWanFHh8vlBPmeHg6NlQGDVYrwr4nPclPUmtpKvL
         Tn7RIz6Ngrc4fgXWbZeebGOevyf7VMNhlQfsU=
Subject: [PATCH] ASoC: Do not update the cache if write to hardware failed
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>
Content-Type: text/plain
Date: Tue, 23 Nov 2010 14:14:07 +0800
Message-Id: <1290492847.7286.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tpa6130a2.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index bfef3da..2d64502 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -77,8 +77,10 @@ static int tpa6130a2_i2c_write(int reg, u8 value)
 
 	if (data->power_state) {
 		val = i2c_smbus_write_byte_data(tpa6130a2_client, reg, value);
-		if (val < 0)
+		if (val < 0) {
 			dev_err(&tpa6130a2_client->dev, "Write failed\n");
+			return val;
+		}
 	}
 
 	/* Either powered on or off, we save the context */
-- 
1.7.2



