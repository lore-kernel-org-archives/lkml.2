Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab2LUF04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:26:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41583 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:26:50 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1e-50d3f319b249
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
In-reply-to: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
Subject: [PATCH 5/6] backlight: tosa: use bl_get_data instead of dev_get_drvdata
Date: Fri, 21 Dec 2012 14:26:48 +0900
Message-id: <001401cddf3b$c6848310$538d8930$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1AAAD9og
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zY13Jz5cDDLpOy1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjiMN7AXH2St6dp1hbGDcwdbFyMkhIWAisf7GNWYIW0ziwr31
	QHEuDiGBZYwS7dceMMMULbjdyQpiCwksYpTYs8YGomg2k8S9XxfBitgE1CS+fDnMDmKLCERI
	NM+YBRTn4GAW8JHYPEsTotdW4sKkL2DlnAJ2Ep27HzGC2MICARIfv1wFi7MIqEps/vyFCcTm
	Bao//u4VK4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW/BVkkIqEs8+qsLcYGRxJdPHVDlIhL7
	XrxjhBgvIPFt8iEWiHJZiU0HmEE+kRCYxy7Rdv0sC8S7khIHV9xgmcAoMQvJ5llINs9CsnkW
	khULGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYoTEldQOxpUNFocYBTgYlXh4Gc0uBwix
	JpYVV+YeYpTgYFYS4fX/ABTiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGDM55XEGxobm5iZ
	mJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAGHVlqjd39bwiycrDfHtvuOxl
	tvypdkN1YqJtQrGuwa7DdwXfr2DZ/DOxsqI2fnP3zs1O+iwVQfIKmZONnkgK//TYea767vf0
	2csrRYodFicEzRGVtQ7Lima9ZLhtGcuSTPturdWpwVs25FlJBXQJME98Zrj7q7RbpZbwSrb6
	W6WrDY++naSjxFKckWioxVxUnAgAa9muFtgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAV3Jz5cDDGZOl7S4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGR1HGtgLjrNX9Ow6w9jA
	uIOti5GTQ0LARGLB7U5WCFtM4sK99WBxIYFFjBJ71th0MXIB2bOZJO79usgMkmATUJP48uUw
	O4gtIhAh0TxjFlCcg4NZwEdi8yxNiF5biQuTvoCVcwrYSXTufsQIYgsLBEh8/HIVLM4ioCqx
	+fMXJhCbF6j++LtXrBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17wFWyUhoC7x6K8uxAVGEl8+
	dUCVi0jse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiO2mdSOxhXNlgcYhTgYFTi4WU0uxwgxJpYVlyZe4hRgoNZSYTX/wNQiDclsbIqtSg/vqg0
	J7X4EKMP0KMTmaVEk/OBCSWvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6YklqdmpqQWoR
	zDgmDk6pBsYzi1gufetwPd4XURZ9Zn/LTSaWReXs6z635v3i+LZE8b10m/U+o0aZzPt8EuuL
	YyW0v+5Tmz1nV8/qiYdW3t3yesXdnj8/dZWSn5dtd/x4bB7bxyU6r0WeJ3Qc1laXtWt+2x4m
	VpuadvHRMkNrfn/eVdL8NVuPPJ679ca79YWmp96IH7cRXxGvxFKckWioxVxUnAgAvR6NSAcD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 588682c..2326fa8 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -54,7 +54,7 @@ static void tosa_bl_set_backlight(struct tosa_bl_data *data, int brightness)
 static int tosa_bl_update_status(struct backlight_device *dev)
 {
 	struct backlight_properties *props = &dev->props;
-	struct tosa_bl_data *data = dev_get_drvdata(&dev->dev);
+	struct tosa_bl_data *data = bl_get_data(dev);
 	int power = max(props->power, props->fb_blank);
 	int brightness = props->brightness;
 
-- 
1.7.2.5


