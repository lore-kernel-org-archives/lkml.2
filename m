Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab1BPApG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:45:06 -0500
Received: from kroah.org ([198.145.64.141]:49288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477Ab1BPAW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.230723017@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Stigge <stigge@antcom.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <Michael.Hennerich@analog.com>
Subject: [171/272] iio: Fixpoint formatted output bugfix
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Stigge <rst@work-microwave.de>

commit e71a7fd259943a2c2e11484880c80248ad139fe5 upstream.

Fix some ADC drivers' _scale interface to correct fixpoint formatted output

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Acked-by: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/adc/ad7476_core.c |    2 +-
 drivers/staging/iio/adc/ad799x_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/adc/ad7476_core.c
+++ b/drivers/staging/iio/adc/ad7476_core.c
@@ -68,7 +68,7 @@ static ssize_t ad7476_show_scale(struct
 	/* Corresponds to Vref / 2^(bits) */
 	unsigned int scale_uv = (st->int_vref_mv * 1000) >> st->chip_info->bits;
 
-	return sprintf(buf, "%d.%d\n", scale_uv / 1000, scale_uv % 1000);
+	return sprintf(buf, "%d.%03d\n", scale_uv / 1000, scale_uv % 1000);
 }
 static IIO_DEVICE_ATTR(in_scale, S_IRUGO, ad7476_show_scale, NULL, 0);
 
--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@ -432,7 +432,7 @@ static ssize_t ad799x_show_scale(struct
 	/* Corresponds to Vref / 2^(bits) */
 	unsigned int scale_uv = (st->int_vref_mv * 1000) >> st->chip_info->bits;
 
-	return sprintf(buf, "%d.%d\n", scale_uv / 1000, scale_uv % 1000);
+	return sprintf(buf, "%d.%03d\n", scale_uv / 1000, scale_uv % 1000);
 }
 
 static IIO_DEVICE_ATTR(in_scale, S_IRUGO, ad799x_show_scale, NULL, 0);


