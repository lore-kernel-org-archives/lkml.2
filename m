Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0KXCQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:16:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48701 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0KXCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uEJcFmoZtisOotei0dr97mGPpXkffF8pqR1evlvafPEBBZOFBNonylF0Rmc9KEgYZS
         PbpqxiTim+RI6MIXc+TeAbnbGFRGqw7OkEpFUjF9iJGh5Tx44nUyvcvgh2l27/aHjGNP
         cJe7MnVAoWk+tbJr4GNhFsion0cD1WK5kjr5o=
Subject: [PATCH 2/2] ASoC: wm8961 - clear WM8961_MCLKDIV bit for freq <=
	16500000
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1290565233.5506.2.camel@mola>
References: <1290565233.5506.2.camel@mola>
Content-Type: text/plain
Date: Wed, 24 Nov 2010 10:21:54 +0800
Message-Id: <1290565314.5506.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCLKDIV bit of Register 04h Clocking1:
	0 : Divide by 1
	1 : Divide by 2

Thus in the case of freq <= 16500000, we should clear MCLKDIV bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8961.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index e4638e6..6b22ef2 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -735,7 +735,7 @@ static int wm8961_set_sysclk(struct snd_soc_dai *dai, int clk_id,
 		freq /= 2;
 	} else {
 		dev_dbg(codec->dev, "Using MCLK/1 for %dHz MCLK\n", freq);
-		reg &= WM8961_MCLKDIV;
+		reg &= ~WM8961_MCLKDIV;
 	}
 
 	snd_soc_write(codec, WM8961_CLOCKING1, reg);
-- 
1.7.2



