Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1ALLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:16:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1ALLQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:16:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pSF8EfreGig5twsgmRlw9rLmE1jCDFEaqqmWLgx0lXkZtafb7FyxNEnLaxRfW635ad
         LVp2KTH4hW+gEkQ67c0selLs0CI6Vucsk2Om4enqQtIodYibDf5bJ3EV3/NB72TLO9FC
         1rrIs6/rfjUB7vJjdqjI7pQXvFGm54IspmoUg=
Subject: [PATCH 1/2] soc_mediabus: export a useful method to obtain the
 number of samples that makes up a pixel format
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: HansVerkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1294830836.2576.46.camel@realization>
References: <1290964687.3016.5.camel@realization>
	 <1290965045.3016.11.camel@realization>
	 <Pine.LNX.4.64.1012011832430.28110@axis700.grange>
	 <Pine.LNX.4.64.1012181722200.18515@axis700.grange>
	 <Pine.LNX.4.64.1012302028100.13281@axis700.grange>
	 <1294076008.2493.85.camel@realization>
	 <Pine.LNX.4.64.1101031931160.23134@axis700.grange>
	 <1294092449.2493.135.camel@realization>
	 <1294830836.2576.46.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 12:16:19 +0100
Message-ID: <1294830979.2576.48.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/media/video/soc_mediabus.c |   14 ++++++++++++++
 include/media/soc_mediabus.h       |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 9139121..5bba424 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -132,6 +132,20 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
 	},
 };
 
+s32 soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf)
+{
+	switch (mf->packing) {
+	case SOC_MBUS_PACKING_NONE:
+	case SOC_MBUS_PACKING_EXTEND16:
+		return 1;
+	case SOC_MBUS_PACKING_2X8_PADHI:
+	case SOC_MBUS_PACKING_2X8_PADLO:
+		return 2;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(soc_mbus_samples_per_pixel);
+
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 {
 	switch (mf->packing) {
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 037cd7b..f21cbd0 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -61,5 +61,6 @@ struct soc_mbus_pixelfmt {
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code);
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
+s32 soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf);
 
 #endif
-- 
1.7.1



