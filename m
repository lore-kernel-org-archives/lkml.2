Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2JVFkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:40:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24051 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2JVFkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:40:10 -0400
X-AuditID: cbfee61b-b7f616d00000319b-6e-5084dc388bac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] backlight: ili9320: add missing SPI dependency
Date: Mon, 22 Oct 2012 14:40:08 +0900
Message-id: <00c901cdb017$b263e540$172bafc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wF7JLoYlBFi5hTGWhk1Rwn0rqYQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAV2LOy0BBtsnW1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mxc332Qumc1a0bFzB2sC4n72LkZNDQsBEYtbB76wQtpjEhXvr
	2boYuTiEBBYxSryf1QSWEBKYzSTxYrUIiM0moCbx5cthsGYRgQiJ5hmzmEFsZoFCiTu/H7OA
	2MICThJH9m4D6uXgYBFQlVg81Q0kzCtgK9Gw5BErhC0o8WPyPRaIVi2JzdsgVjELyEtsXvOW
	GaRVQkBd4tFfXYhNehJvNtxlgigRkdj34h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERyUz6R3MK5qsDjEKMDBqMTDazGjJUCINbGsuDL3EKMEB7OS
	CO+peKAQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAhgfTEktTs1NSC1CKYLBMHp1QD48zU
	psyPG9uexvV72fPsvB1lYKLv/8LlhsXOoEffo5686+99U35a9o7j5N2HLz2Ol37CpRXEwhx7
	sWHNc+tZLIJzpIplLS5+KzC7X/aXs+XdAl/nheuKv/U73pXdcUUj/W9Asn+d83/zbQbf4vZ9
	M59/+F2rfP2LPUv43c7G5HuLxWaaud/5rsRSnJFoqMVcVJwIAM9oJTVGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds this missing SPI dependency and prevents
the driver from buiding without SPI, because funtion of
spi driver is used in this driver. So, it fixes link error
as belows:

drivers/video/backlight/ili9320.c:51: undefined reference to `spi_sync'

Also, prompt string for CONFIG_LCD_ILI9320 is added for
explicit selection.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ben Dooks <ben-linux@fluff.org>
---
Changes since v1:
- commit log is modified to be more specific.

 drivers/video/backlight/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index c101697..765a945 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -60,7 +60,8 @@ config LCD_LTV350QV
 	  The LTV350QV panel is present on all ATSTK1000 boards.
 
 config LCD_ILI9320
-	tristate
+	tristate "ILI Technology ILI9320 controller support"
+	depends on SPI
 	help
 	  If you have a panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
-- 
1.7.1


