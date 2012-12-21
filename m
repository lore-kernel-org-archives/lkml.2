Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab2LUF0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:26:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUF03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:26:29 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-57-50d3f304aa1e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
In-reply-to: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
Subject: [PATCH 4/6] backlight: corgi_lcd: use bl_get_data instead of
 dev_get_drvdata
Date: Fri, 21 Dec 2012 14:26:28 +0900
Message-id: <001301cddf3b$ba29d2a0$2e7d77e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1AAAC21g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zI12Wz5cDDFa90bS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZE97/YiqYzlnxeuZt1gbGu+xdjJwcEgImEq83LICyxSQu3FvP
	1sXIxSEksIxRYveVL2wwRdsn9zNBJKYzSnxf1s8KkhASmM0ksW2dGojNJqAm8eXLYbBJIgIR
	Es0zZjF3MXJwMAv4SGyepQlRbitxYdIXZhCbU8BOonP3I0aQEmGBcIn+S2BhFgFViUUXLjCB
	2LxA5bdnr4WyBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt2CYJAXWJR391IQ4wkmi+9YwVokRE
	Yt+Ld4wQ4wUkvk0+xAJRLiux6QAzxIPz2CUm/nGFsCUlDq64wTKBUWIWksWzkCyehWTxLCQb
	FjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIiSmpHYwrGywOMQpwMCrx8DKaXQ4QYk0s
	K67MPcQowcGsJMLr/wEoxJuSWFmVWpQfX1Sak1p8iNEH6PCJzFKiyfnAeM8riTc0NjYxMzE1
	Mbc0NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgbFjGq/31EuptTN3fFvx+N0Muc/n
	3TPE32wOy93x+b2a2OV3t1M1DBqOTnvwR62uUMR3gpuOx763Hzd5zzlhPk1kgsWElGvq76os
	t86O83lVmnj8yf6lyYHmLRXPX2fsVhHvDfGPLjtj8I2fJfilzU0x7pdtAu+vRR7csbXg3Rfx
	qPszo01Fb1xVYinOSDTUYi4qTgQABmrLdtYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV2Wz5cDDH7tU7O4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGRPe/2IqmM5Z8XrmbdYG
	xrvsXYycHBICJhLbJ/czQdhiEhfurWfrYuTiEBKYzijxfVk/K0hCSGA2k8S2dWogNpuAmsSX
	L4fBmkUEIiSaZ8xi7mLk4GAW8JHYPEsTotxW4sKkL8wgNqeAnUTn7keMICXCAuES/ZfAwiwC
	qhKLLlwAW8sLVH579looW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWvegm2SEFCXePRXF+IAI4nm
	W89YIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn
	525iBMfsM6kdjCsbLA4xCnAwKvHwMppdDhBiTSwrrsw9xCjBwawkwuv/ASjEm5JYWZValB9f
	VJqTWnyI0Qfo0YnMUqLJ+cB0klcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7NbUg
	tQhmHBMHp1QDI9+WLdMqtt57yZjNsGPeF+E77d+apvpwcj8OijjwdUn5vqXCYqXu3uJrjf2t
	6mxVVz7dfkY7N0fWZl9ZFWvMdX9tkY8RC+PXiit3WByr2fZ8Wuaq14z3EveaLJXQYJtmOGF+
	yCmTSTEs+xg2Ha2VmZtsODUmKf7jkqeaCtbZZktPXAtfERjkosRSnJFoqMVcVJwIAFS8NmYG	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/corgi_lcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 77c81f8..13ef511 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -391,7 +391,7 @@ static struct lcd_ops corgi_lcd_ops = {
 
 static int corgi_bl_get_intensity(struct backlight_device *bd)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&bd->dev);
+	struct corgi_lcd *lcd = bl_get_data(bd);
 
 	return lcd->intensity;
 }
@@ -423,7 +423,7 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
 
 static int corgi_bl_update_status(struct backlight_device *bd)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&bd->dev);
+	struct corgi_lcd *lcd = bl_get_data(bd);
 	int intensity = bd->props.brightness;
 
 	if (bd->props.power != FB_BLANK_UNBLANK)
-- 
1.7.2.5


