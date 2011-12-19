Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab1LSIj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:39:59 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42443 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1LSIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:39:57 -0500
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: Thomas Meyer <thomas@m3y3r.de>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Dec 2011 14:08:16 +0530
Subject: RE: [PATCH] [SCSI] mptfusion: Use kmemdup rather than duplicating
 its implementation
Thread-Topic: [PATCH] [SCSI] mptfusion: Use kmemdup rather than duplicating
 its implementation
Thread-Index: Acymroq/8n/dxvd5SaeuTPTDB7O7XQXev4EA
Message-ID: <A6888A6805518E4EA4AF7072A28264A60481D59EDA@inbmail02.lsi.com>
References: <1321569820.1624.287.camel@localhost.localdomain>
In-Reply-To: <1321569820.1624.287.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBJ8e81X028973

This patch seem to be fine.
Please consider this patch as acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: Thomas Meyer [mailto:thomas@m3y3r.de] 
Sent: Friday, November 18, 2011 4:14 AM
To: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] mptfusion: Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c 2011-11-07 19:37:51.796676955 +0100
+++ b/drivers/message/fusion/mptbase.c 2011-11-08 10:40:23.121014643 +0100
@@ -6003,13 +6003,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
 
-	mem = kmalloc(iocpage2sz, GFP_KERNEL);
+	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
 	if (!mem) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 
 	mpt_read_ioc_pg_3(ioc);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
