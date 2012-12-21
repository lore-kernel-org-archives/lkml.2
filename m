Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2LUFSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:18:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56737 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LUFS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:18:29 -0500
X-AuditID: cbfee61b-b7f616d00000319b-1a-50d3f123a2b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/11] backlight: l4f00242t03: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:18:27 +0900
Message-id: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+Q==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ13lj5cDDD6esrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ3fteMRZcF6pouzGDrYHxDX8XIweHhICJxOcHul2MnECmmMSF
	e+vZuhi5OIQEljFKzGpvZoFImEgce7+CGSKxiFFi9pEGVghnNpPEwQ8/mEGq2ATUJL58OcwO
	YosIREg0z5jFDLKBWcBHYvMsTZCwMFD45c89rCA2i4CqRPv+12DlvAK2Eo/3XmGGsAUlfky+
	B7aYWUBLYv3O40wQtrzE5jVvmSGOVpd49FcXYpOexJuOn1DlIhL7XrxjhBgvIPFt8iEWiHJZ
	iU0HwM6XEGhml7iyroEZ4i9JiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxQuJEegfjqgaLQ4wCHIxKPLyRFpcDhFgTy4orcw8xSnAwK4nwPl8C
	FOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YAznlcQbGhubmJmYmphbmpqb4hBWEudt9kgJ
	EBJITyxJzU5NLUgtghnHxMEp1cCY685TGJG8QGNSy/zvDz4dENkQlH/7yp6NRgI73J7NOjb3
	5fPZSS/PvAn+fefg7n2zds1xmmlR+Gzfx6zpZW/tFLVCz3u0pWzvktlncP7sYR2nAjGZJYdn
	hua/LhRcv/X13qcyG/ryM0uu8npLLZtwpHaa/Da3ebdlS85wJE5beraB83qtb9G+Z0osxRmJ
	hlrMRcWJAOiR9jPAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV3lj5cDDPa+NLa4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGd37XjEWXBeqaLsxg62B
	8Q1/FyMnh4SAicSx9yuYIWwxiQv31rN1MXJxCAksYpSYfaSBFcKZzSRx8MMPsCo2ATWJL18O
	s4PYIgIREs0zZgHFOTiYBXwkNs/SBAkLA4Vf/tzDCmKzCKhKtO9/DVbOK2Ar8XjvFWYIW1Di
	x+R7LCA2s4CWxPqdx5kgbHmJzWvego2UEFCXePRXF2KTnsSbjp9Q5SIS+168Y5zAKDALyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/CZ9A7GVQ0WhxgFOBiV
	eHgjLS4HCLEmlhVX5h5ilOBgVhLhfb4EKMSbklhZlVqUH19UmpNafIjRB+jRicxSosn5wBSR
	VxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjRH632KoT0rsD
	SiTYVdYrxkUErYxYsveLntkZ0w8hPH3L9dL5LS+Uye+8equ2MvbLLbvwBbfaYzSFL9rwmWZ+
	m9733SK2a/nlVdX7ucUrhO+srD26SU30oqTU8rDLn0wCd+9PNJCx8vjOW76et335BGtHxb35
	ezkd5zyOcT5jeSXQ7lTHtxYlluKMREMt5qLiRADDX0UQ8AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/l4f00242t03.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 9a35196..9bef9cf 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -49,7 +49,7 @@ static void l4f00242t03_reset(unsigned int gpio)
 static void l4f00242t03_lcd_init(struct spi_device *spi)
 {
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
@@ -70,7 +70,7 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
 {
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "Powering down LCD\n");
 
@@ -168,7 +168,7 @@ static int l4f00242t03_probe(struct spi_device *spi)
 		return -ENOMEM;
 	}
 
-	dev_set_drvdata(&spi->dev, priv);
+	spi_set_drvdata(spi, priv);
 	spi->bits_per_word = 9;
 	spi_setup(spi);
 
@@ -231,12 +231,12 @@ err1:
 
 static int l4f00242t03_remove(struct spi_device *spi)
 {
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	regulator_put(priv->io_reg);
 	regulator_put(priv->core_reg);
@@ -246,7 +246,7 @@ static int l4f00242t03_remove(struct spi_device *spi)
 
 static void l4f00242t03_shutdown(struct spi_device *spi)
 {
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	if (priv)
 		l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
-- 
1.7.2.5


