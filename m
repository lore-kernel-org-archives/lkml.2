Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2JYLDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:03:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46006 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab2JYLDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:03:23 -0400
X-AuditID: cbfee61b-b7f616d00000319b-c6-50891c79138e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'H Hartley Sweeten'" <hsweeten@visionengravers.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: ep93xx: fix section mismatch
Date: Thu, 25 Oct 2012 20:03:21 +0900
Message-id: <001001cdb2a0$58c17f80$0a447e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2yoFiqa8gwXpqqSuWkk7J8877xPg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd1Kmc4Ag7ffLS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtflWBYt4Km7t28zewLiHq4uRk0NCwESi+dM5FghbTOLCvfVs
	XYxcHEICixglXi09zA7hzGaS2PxiPyNIFZuAmsSXLyAJTg4RgQiJ5hmzmEGKmAVaGCWuvLzA
	DJIQFrCRuHKiGWwsi4CqxJUrbUwgNq+ArcSp3gOMELagxI/J98BqmAW0JNbvPM4EYctLbF7z
	FmgOB9BJ6hKP/upC7NKT+Pv1NDtEiYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgwHwmvYNxVYPFIUYBDkYlHt6DHh0BQqyJZcWVuYcYJTiY
	lUR4t78HCvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJzU5NLUgtgskycXBKNTDK
	3vi8a+oGvUo52xPZOwSnzp7kn+co6RieNnVvRpR56B3v2Xbv3fiiPogHWBd/uSW8y4jFMfcl
	s2RksHJdy5VQmed+z1iCa3Ztq5gxV4nn0VaTnwvkrr32s7kbnri0V9/o38H1s4KXxD9ty/nv
	+rXtnmty0lnB/40xDq/+TBDSyJjj5iH7ulWJpTgj0VCLuag4EQAlmRKESAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section mismatch warning as below:

WARNING: drivers/video/backlight/built-in.o(.data+0x110): Section mismatch in reference from the variable ep93xxbl_driver to the
function .init.text:ep93xxbl_probe()
The variable ep93xxbl_driver references
the function __init ep93xxbl_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/ep93xx_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 08214e1..d0c688b 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int __devinit ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
@@ -106,7 +106,7 @@ static int __init ep93xxbl_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
+static int __devexit ep93xxbl_remove(struct platform_device *dev)
 {
 	struct backlight_device *bl = platform_get_drvdata(dev);
 
-- 
1.7.1


