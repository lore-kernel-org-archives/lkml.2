Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2JWEVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:21:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64628 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2JWEVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:21:18 -0400
X-AuditID: cbfee61b-b7f616d00000319b-18-50861b3d6e17
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 4/4] backlight: vgg2432a4: add missing const
Date: Tue, 23 Oct 2012 13:21:17 +0900
Message-id: <000c01cdb0d5$d8b62230$8a226690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w1XpVbfPt/OpOQ+KIRjYTosJjAAAAEIwA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV1b6bYAg0kLVCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG0sXH2AvmilZsvriKuYGxT7CLkZNDQsBE4uan18wQtpjEhXvr
	2boYuTiEBBYxSjya+4UJwpnNJNGxp5UVpIpNQE3iy5fD7CC2iECERPOMWWDdzAKFEnd+P2bp
	YuQAauCWWN0cBBLmFOCRWPenE6xEWMBGYvGD3WCtLAKqElfXLmUBsXkFbCXe3N3ICGELSvyY
	fI8FYqSWxPqdx5kgbHmJzWveMoOMlxBQl3j0VxfiAiOJU+1TGSFKRCT2vXjHOIFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH8TPpHYyrGiwOMQpwMCrx
	8Hbsbw0QYk0sK67MPcQowcGsJMKrHAAU4k1JrKxKLcqPLyrNSS0+xCjNwaIkztvskRIgJJCe
	WJKanZpakFoEk2Xi4JRqYNy0ZKMr391/7Uvenz5wfPKNuWcyFdfcOfN9scCnp6ZZSh/8Hna/
	LFnn+3rh613tbpNDX/HPKQm7y1EtFbYsn+PjRE2D/ZMvL9Jd/GWz/nvDKa2/hDLNnqRIyOse
	SlN//cJ48uc9Xoes2EK2fkn8XysrmnxFgsvjZsoGiSdqHEuMpV6537ZKX/VLiaU4I9FQi7mo
	OBEANFZCH18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'const' to static array that was missing it in its
definition. Also, 'const' is added to ili9320_write_regs(),
because it is called by vgg2432a4 driver.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/ili9320.c   |    2 +-
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 9327cd1..8ec9484 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -60,7 +60,7 @@ int ili9320_write(struct ili9320 *ili, unsigned int reg, unsigned int value)
 EXPORT_SYMBOL_GPL(ili9320_write);
 
 int ili9320_write_regs(struct ili9320 *ili,
-		       struct ili9320_reg *values,
+		       const struct ili9320_reg *values,
 		       int nr_values)
 {
 	int index;
diff --git a/drivers/video/backlight/ili9320.h b/drivers/video/backlight/ili9320.h
index e388eca..e0db738 100644
--- a/drivers/video/backlight/ili9320.h
+++ b/drivers/video/backlight/ili9320.h
@@ -63,7 +63,7 @@ extern int ili9320_write(struct ili9320 *ili,
 			 unsigned int reg, unsigned int value);
 
 extern int ili9320_write_regs(struct ili9320 *ili,
-			      struct ili9320_reg *values,
+			      const struct ili9320_reg *values,
 			      int nr_values);
 
 /* Device probe */
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index b617fae..38c4bb1 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -26,7 +26,7 @@
 
 /* Device initialisation sequences */
 
-static struct ili9320_reg vgg_init1[] = {
+static const struct ili9320_reg vgg_init1[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value	 = ILI9320_POWER1_AP(0) | ILI9320_POWER1_BT(0),
@@ -43,7 +43,7 @@ static struct ili9320_reg vgg_init1[] = {
 	},
 };
 
-static struct ili9320_reg vgg_init2[] = {
+static const struct ili9320_reg vgg_init2[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value   = (ILI9320_POWER1_AP(3) | ILI9320_POWER1_APE |
@@ -54,7 +54,7 @@ static struct ili9320_reg vgg_init2[] = {
 	}
 };
 
-static struct ili9320_reg vgg_gamma[] = {
+static const struct ili9320_reg vgg_gamma[] = {
 	{
 		.address = ILI9320_GAMMA1,
 		.value	 = 0x0000,
@@ -89,7 +89,7 @@ static struct ili9320_reg vgg_gamma[] = {
 
 };
 
-static struct ili9320_reg vgg_init0[] = {
+static const struct ili9320_reg vgg_init0[] = {
 	[0]	= {
 		/* set direction and scan mode gate */
 		.address = ILI9320_DRIVER,
-- 
1.7.1


