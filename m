Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0GNK5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:57:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39265 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OP2a9Kc3/aX8J7dNPLW9MgHAmTfNl29P7sL1VFfSaptgsiguj+oI2kDLHrsXK3D0PG
         NdX2+HtYvZC8+Y877WTBjRKIt09G0uF5KP5ay02oU341jcySJ88PW39sSL6U6i9Mg/eS
         4md8p34MxwcK/OZnbnk2hv9xOI5EF2rB3RA5s=
Subject: [PATCH] wm8727: add a missing return in wm8727_platform_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, Neil Jones <neil.jones@imgtec.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 18:57:31 +0800
Message-ID: <1279105051.2290.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

otherwise the error path will always be executed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8727.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8727.c b/sound/soc/codecs/wm8727.c
index 1072621..9d1df26 100644
--- a/sound/soc/codecs/wm8727.c
+++ b/sound/soc/codecs/wm8727.c
@@ -127,6 +127,8 @@ static __devinit int wm8727_platform_probe(struct platform_device *pdev)
 		goto err_codec;
 	}
 
+	return 0;
+
 err_codec:
 	snd_soc_unregister_codec(codec);
 err:
-- 
1.7.0.4



