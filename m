Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab0HSGht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:37:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43510 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0HSGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ng/yCyvncbtB8WSQQF3Ty1AoCb2BsmSBUwXUE8CGzNHuYzrjjvS9EGxW0YhH4s2Voc
         m1pSrlihKCkHu5ekxmG7Ei6y5cce9OyNCWynLi6Z5K1OOemxSHAEldtrmLgf/RlKqyXJ
         NQaMMgUYDwQHiI1+FIf6BTWBtvtHeHZDQD26k=
Subject: [PATCH] ASoC: e740_wm9705 - free gpio in e740_exit()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ian Molton <ian@mnementh.co.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 19 Aug 2010 14:40:25 +0800
Message-Id: <1282200025.9347.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In e740_init(), we call gpio_request() for
GPIO_E740_MIC_ON, GPIO_E740_AMP_ON and GPIO_E740_WM9705_nAVDD2.
We should free the these gpio accordingly in e740_exit().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/e740_wm9705.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/soc/pxa/e740_wm9705.c b/sound/soc/pxa/e740_wm9705.c
index 7cd2f89..515faeb 100644
--- a/sound/soc/pxa/e740_wm9705.c
+++ b/sound/soc/pxa/e740_wm9705.c
@@ -200,6 +200,9 @@ free_mic_amp_gpio:
 static void __exit e740_exit(void)
 {
 	platform_device_unregister(e740_snd_device);
+	gpio_free(GPIO_E740_WM9705_nAVDD2);
+	gpio_free(GPIO_E740_AMP_ON);
+	gpio_free(GPIO_E740_MIC_ON);
 }
 
 module_init(e740_init);
-- 
1.7.2



