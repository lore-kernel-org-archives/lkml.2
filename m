Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab0HTFUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:20:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab0HTFUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YLyrzdTes3p1kR8jS/2+hekCcKc3HuUie1M4/OTdsQrWofzGhxYQlMP2bdC/DqotWC
         MX0JNcJqMMcbUH2/fG3qxOEJk4ZhQZ17PXSaO2e4PSPAibKMZoUh0b/1SH6kFJxbtfwh
         UD3PaUsxtfLvYhyO6sGBsmQtxHUlBp82u5iJE=
Subject: [PATCH] ASoC: multi-component: remove include of pxa2xx-pcm.h in
	pxa2xx-ac97.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nico@cam.org>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 13:23:36 +0800
Message-Id: <1282281816.7214.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reference to moved header file, which was unused anyway.
This change fixes below build error:
  CC      sound/soc/pxa/pxa2xx-ac97.o
sound/soc/pxa/pxa2xx-ac97.c:27:24: error: pxa2xx-pcm.h: No such file or directory
make[3]: *** [sound/soc/pxa/pxa2xx-ac97.o] Error 1
make[2]: *** [sound/soc/pxa] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I encountered the build error in today's linux-next tree. ( next-20100820 ).
Looks like this patch can also be applied to multi-component branch.

Axel

 sound/soc/pxa/pxa2xx-ac97.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/pxa/pxa2xx-ac97.c b/sound/soc/pxa/pxa2xx-ac97.c
index 9c2bafa..ac51c6d 100644
--- a/sound/soc/pxa/pxa2xx-ac97.c
+++ b/sound/soc/pxa/pxa2xx-ac97.c
@@ -24,7 +24,6 @@
 #include <mach/dma.h>
 #include <mach/audio.h>
 
-#include "pxa2xx-pcm.h"
 #include "pxa2xx-ac97.h"
 
 static void pxa2xx_ac97_warm_reset(struct snd_ac97 *ac97)
-- 
1.7.2



