Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2JSC2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:28:01 -0400
Received: from mxsmtp1.mxic.com.tw ([220.228.149.226]:37524 "EHLO
	twhmllg3.macronix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751710Ab2JSC2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:28:00 -0400
Subject: [PATCH v2] m25p80: Add support of Macronix SPI flash
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF1E89886E.8C80DE01-ON48257A9C.000D4C08-48257A9C.000D8A63@mxic.com.tw>
From: jimkuo@mxic.com.tw
Date: Fri, 19 Oct 2012 10:27:59 +0800
X-MIMETrack: Serialize by Router on MXML01A/TAIWAN/MXIC(Release 7.0.4FP2|June 06, 2010) at
 2012/10/19 10:27:52
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: twhmllg3.macronix.com q9J2RrD8081503
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
I'm an engineer of Macronix. I have sent you a m25p80 patch few weeks ago.
This is an update version of that one.

I replaced the old jedec id with our new product's. And add "write enable"
feature to our chips.
Two of our products have different page size, so I add an "if statement"
before page size assignment.
The following is m25p80 patch "diff" from Linux-3.6 kernel:
--

--- drivers/mtd/devices/m25p80.c.orig     2012-10-19 10:10:36.017581000
+0800
+++ drivers/mtd/devices/m25p80.c    2012-10-19 10:14:55.294198000 +0800
@@ -648,13 +648,31 @@ static const struct spi_device_id m25p_i
      { "640s33b",  INFO(0x898913, 0, 64 * 1024, 128, 0) },

      /* Macronix */
-     { "mx25l2005a",  INFO(0xc22012, 0, 64 * 1024,   4, SECT_4K) },
-     { "mx25l4005a",  INFO(0xc22013, 0, 64 * 1024,   8, SECT_4K) },
-     { "mx25l8005",   INFO(0xc22014, 0, 64 * 1024,  16, 0) },
-     { "mx25l1606e",  INFO(0xc22015, 0, 64 * 1024,  32, SECT_4K) },
-     { "mx25l3205d",  INFO(0xc22016, 0, 64 * 1024,  64, 0) },
-     { "mx25l6405d",  INFO(0xc22017, 0, 64 * 1024, 128, 0) },
-     { "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
+     { "mx25l512e",   INFO(0xc22010, 0, 64 * 1024,   1, SECT_4K) },
+     { "mx25l5121e",  INFO(0xc22210, 0, 64 * 1024,   1, SECT_4K) },
+     { "mx25l1006e",  INFO(0xc22011, 0, 64 * 1024,   2, SECT_4K) },
+     { "mx25l1021e",  INFO(0xc22211, 0, 64 * 1024,   2, SECT_4K) },
+     { "mx25l2006e",  INFO(0xc22012, 0, 64 * 1024,   4, SECT_4K) },
+     { "mx25l4006e",  INFO(0xc22013, 0, 64 * 1024,   8, SECT_4K) },
+     { "mx25u4035",   INFO(0xc22533, 0, 64 * 1024,   8, SECT_4K) },
+     { "mx25v4035",   INFO(0xc22553, 0, 64 * 1024,   8, SECT_4K) },
+     { "mx25l8006e",  INFO(0xc22014, 0, 64 * 1024,  16, 0) },
+     { "mx25u8035",   INFO(0xc22534, 0, 64 * 1024,  16, 0) },
+     { "mx25v8035",   INFO(0xc22554, 0, 64 * 1024,  16, 0) },
+     { "mx25l1606e",  INFO(0xc22015, 0, 64 * 1024,  32, 0) },
+     { "mx25l1633e",  INFO(0xc22415, 0, 64 * 1024,  32, 0) },
+     { "mx25l1635e",  INFO(0xc22515, 0, 64 * 1024,  32, 0) },
+     { "mx25u1635e",  INFO(0xc22535, 0, 64 * 1024,  32, 0) },
+     { "mx25l1655d",  INFO(0xc22615, 0, 64 * 1024,  32, 0) },
+     { "mx25l3206e",  INFO(0xc22016, 0, 64 * 1024,  64, 0) },
+     { "mx25l3239e",  INFO(0xc22536, 0, 64 * 1024,  64, 0) },
+     { "mx25l3225d",  INFO(0xc25e16, 0, 64 * 1024,  64, 0) },
+     { "mx25l3255d",  INFO(0xc29e16, 0, 64 * 1024,  64, 0) },
+     { "mx25l6406e",  INFO(0xc22017, 0, 64 * 1024, 128, 0) },
+     { "mx25l6439e",  INFO(0xc22537, 0, 64 * 1024, 128, 0) },
+     { "mx25l6455e",  INFO(0xc22617, 0, 64 * 1024, 128, 0) },
+     { "mx25l12806e", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
+     { "mx25u12835f", INFO(0xc22538, 0, 64 * 1024, 256, 0) },
      { "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 0) },
      { "mx25l25635e", INFO(0xc22019, 0, 64 * 1024, 512, 0) },
      { "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
@@ -868,7 +886,8 @@ static int __devinit m25p_probe(struct s

      if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ATMEL ||
          JEDEC_MFR(info->jedec_id) == CFI_MFR_INTEL ||
-         JEDEC_MFR(info->jedec_id) == CFI_MFR_SST) {
+         JEDEC_MFR(info->jedec_id) == CFI_MFR_SST ||
+         JEDEC_MFR(info->jedec_id) == CFI_MFR_MACRONIX) {
            write_enable(flash);
            write_sr(flash, 0);
      }
@@ -905,7 +924,11 @@ static int __devinit m25p_probe(struct s

      ppdata.of_node = spi->dev.of_node;
      flash->mtd.dev.parent = &spi->dev;
-     flash->page_size = info->page_size;
+     /* small size page of Macronix chip */
+     if (info->jedec_id == 0xc22210 || info->jedec_id == 0xc22211)
+           flash->page_size = 32;
+     else
+           flash->page_size = info->page_size;
      flash->mtd.writebufsize = flash->page_size;

      if (info->addr_width)

--



============================================================================

CONFIDENTIALITY NOTE:

This e-mail and any attachments may contain confidential information and may be protected by legal privilege. If you are not the intended addressee (or authorized to receive for the addressee), be aware that any disclosure, copying, distribution or use of this e-mail or any attachment is prohibited. If you have received this e-mail in error, please notify us immediately by returning it to the sender and delete this copy from your system. Thank you for your cooperation.

Macronix International Co., Ltd.

=====================================================================

