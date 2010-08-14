Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab0HNClA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:41:00 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:12737 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0HNCk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:40:58 -0400
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Dan Carpenter <error27@gmail.com>, Ravi Anand <ravi.anand@qlogic.com>
CC: Dept_iscsi_driver <iscsi-driver@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Karen Higgins <karen.higgins@qlogic.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 13 Aug 2010 19:40:51 -0700
Subject: RE: [patch] qla4xxx: initialize some variables for gcc
Thread-Topic: [patch] qla4xxx: initialize some variables for gcc
Thread-Index: Acs7KxeA9WQu3N2gQ9OLl/y8J4D4/QALU2eA
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128F84727@AVEXMB1.qlogic.org>
References: <20100813210350.GT645@bicker>
In-Reply-To: <20100813210350.GT645@bicker>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7E2fYoM021687

>-----Original Message-----
>From: Dan Carpenter [mailto:error27@gmail.com]
>Sent: Saturday, August 14, 2010 2:34 AM
>To: Ravi Anand
>Cc: Vikas Chaudhary; Dept_iscsi_driver; James E.J. Bottomley; Karen
>Higgins; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
>janitors@vger.kernel.org
>Subject: [patch] qla4xxx: initialize some variables for gcc
>
>Gcc complains because these variables aren't initialized.
>
>drivers/scsi/qla4xxx/ql4_nx.c: In function â€˜qla4_8xxx_get_flash_infoâ€™:
>drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: â€˜fidâ€™ may be used
>uninitialized in this function
>drivers/scsi/qla4xxx/ql4_nx.c:1952: note: â€˜fidâ€™ was declared here
>drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: â€˜midâ€™ may be used
>uninitialized in this function
>drivers/scsi/qla4xxx/ql4_nx.c:1952: note: â€˜midâ€™ was declared here
>
>It's not a big deal.  We only print the uninitialized value on error
>paths when debugging is enabled.  Still it's nice to clean it up and to
>stop gcc from grumbling.
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>
>
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index 3e119ae..e443fa6 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -1949,7 +1949,8 @@ qla4_8xxx_get_fdt_info(struct scsi_qla_host *ha)
> 	uint16_t cnt, chksum;
> 	uint16_t *wptr;
> 	struct qla_fdt_layout *fdt;
>-	uint16_t mid, fid;
>+	uint16_t mid = -1;
>+	uint16_t fid = -1;
> 	struct ql82xx_hw_data *hw = &ha->hw;
>
> 	hw->flash_conf_off = FARX_ACCESS_FLASH_CONF;

I already submitted patch to fix this warning in following mail thread.
http://marc.info/?l=linux-scsi&m=128152158403853&w=2

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
