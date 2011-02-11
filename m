Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1BKMaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:30:03 -0500
Received: from ni.piap.pl ([195.187.100.4]:39784 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1BKMaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:30:00 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:29:59 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m3d3myrby0.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 3/7] Solo6x10: Align MPEG video on 8-byte boundary instead of 32-byte.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solo-6110 only supports 8-byte alignment anyway.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/solo6010-enc.c b/drivers/staging/solo6x10/solo6010-enc.c
index 481a492..7e28f7d 100644
--- a/drivers/staging/solo6x10/solo6010-enc.c
+++ b/drivers/staging/solo6x10/solo6010-enc.c
@@ -176,7 +176,6 @@ static void solo_mp4e_config(struct solo6010_dev *solo_dev)
 		       SOLO_VE_BLOCK_BASE(SOLO_MP4E_EXT_ADDR(solo_dev) >> 16));
 
 	solo_reg_write(solo_dev, SOLO_VE_CFG1,
-		       SOLO_VE_BYTE_ALIGN(2) |
 		       SOLO_VE_INSERT_INDEX | SOLO_VE_MOTION_MODE(0));
 
 	solo_reg_write(solo_dev, SOLO_VE_WMRK_POLY, 0);
diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index 47f6e04..ccee5b8 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -754,7 +754,7 @@ void solo_enc_v4l2_isr(struct solo6010_dev *solo_dev)
 
 	cur_q = ((solo_reg_read(solo_dev, SOLO_VE_STATE(11)) & 0xF) + 1) % MP4_QS;
 
-	reg_mpeg_size = ((solo_reg_read(solo_dev, SOLO_VE_STATE(0)) & 0xFFFFF) + 64 + 32) & ~31;
+	reg_mpeg_size = ((solo_reg_read(solo_dev, SOLO_VE_STATE(0)) & 0xFFFFF) + 64 + 8) & ~7;
 
 	while (solo_dev->enc_idx != cur_q) {
 		mpeg_current = solo_reg_read(solo_dev,

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
