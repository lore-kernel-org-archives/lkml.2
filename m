Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0GOCuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:50:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0GOCuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PRMrmSntAVpS5pqRfvpaEyl1+7IVRt18321TcTuW6ZCb6GFqPMw/gJhBJytmoFUET+
         A1uSawntICDmREgdkgxpqgWgNI6FL2L+ywXLJdFLfaXus5fRbl//Y7H8O0LITEEdZzPP
         SbORBu4TlrjlNXrik5sZweZ6ihxMMS9QWcNIg=
Subject: [PATCH 1/12] ad1836: fix a memory leak if another ad1836 is
	registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Barry Song <Barry.Song@analog.com>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:50:37 +0800
Message-Id: <1279162237.29294.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ad1836 is allocated in ad1836_spi_probe() but is not freed if ad1836_register()
return -EINVAL (if another ad1836 is registered).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad1836.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 2175384..a01006c 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -272,6 +272,7 @@ static int ad1836_register(struct ad1836_priv *ad1836)
 
 	if (ad1836_codec) {
 		dev_err(codec->dev, "Another ad1836 is registered\n");
+		kfree(ad1836);
 		return -EINVAL;
 	}
 
-- 
1.5.4.3



