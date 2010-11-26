Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0KZGsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 01:48:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0KZGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 01:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vUjlVcLeHXPgPNrGy3zcJeT6lB0C92suHV6sDpC7ijKpMqJaGdBUEyW3RRQzH67KvK
         TD7cCoKlvQHkGvKIuiVOktTaNdCSq+9LDMZho0GTinynYkRxl5+YMAaYL3Vt3ALWwMvZ
         cTbfi/4bn/6eEdZF8KKfyjpP/OsNbS4fm6lmo=
Subject: [PATCH 3/4] ASoC: Add missing gpio_free(S3C64XX_GPK(12)) in
	smartq_exit()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290754245.25125.1.camel@mola>
References: <1290754245.25125.1.camel@mola>
Content-Type: text/plain
Date: Fri, 26 Nov 2010 14:53:38 +0800
Message-Id: <1290754418.25125.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/smartq_wm8987.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index 0a46fa8..61e2b52 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -274,6 +274,7 @@ err_unregister_device:
 
 static void __exit smartq_exit(void)
 {
+	gpio_free(S3C64XX_GPK(12));
 	snd_soc_jack_free_gpios(&smartq_jack, ARRAY_SIZE(smartq_jack_gpios),
 				smartq_jack_gpios);
 
-- 
1.7.2



