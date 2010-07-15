Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0GOCve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:51:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64448 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0GOCvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nd+gAslSOukPVINfkZKWP0yF6u2I62r+++nvBxyJykx4jrI4uZ3RvOEGRZI4o9ThxZ
         2a7GpA/gxoHxn+crkbboJQTO/vOnvHmj3bR8klx1hdT3cXYMnZuhevtfpmfIf7/oUpZH
         BRB6Pq7nIg3WU3NJVF01axrQGSS4hhj9Ma7dA=
Subject: [PATCH 2/12] ak4642: fix a memory leak if failed to initialise
	AK4642
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:52:09 +0800
Message-Id: <1279162329.29294.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ak4642 should be kfreed if ak4642_init() return error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4642.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 7528a54..4feefa8 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -491,8 +491,10 @@ static int ak4642_i2c_probe(struct i2c_client *i2c,
 	codec->control_data = i2c;
 
 	ret = ak4642_init(ak4642);
-	if (ret < 0)
+	if (ret < 0) {
 		printk(KERN_ERR "failed to initialise AK4642\n");
+		kfree(ak4642);
+	}
 
 	return ret;
 }
-- 
1.5.4.3



