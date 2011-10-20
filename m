Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1JTNg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:36:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39153 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1JTNgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:36:55 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Failed to set xfermode (err_mask=0x4) with PIONEER DVRTD08A
Date: Thu, 20 Oct 2011 15:36:43 +0200
Message-ID: <5076334.A6YMT6Muoz@qosmio-x300>
User-Agent: KMail/4.7.2 (Linux/3.0.7-ck1-ARCHMOD; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I haven't had this problem until the upgrade to 3.0 kernel. If I recall correctly, all 3.0.x versions except 3.0.3 needed this patch to get my DVD drive working, I've no idea what changed that the A-less entry in libata-core.c no longer works with the DVRTD08A drive.

---
--- linux-3.0.7/drivers/ata/libata-core.c.old	2011-10-16 23:15:11.000000000 +0200
+++ linux-3.0.7/drivers/ata/libata-core.c	2011-10-20 15:25:12.730104223 +0200
@@ -4144,6 +4144,7 @@
 	 * device and controller are SATA.
 	 */
 	{ "PIONEER DVD-RW  DVRTD08",	NULL,	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVRTD08A",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 

