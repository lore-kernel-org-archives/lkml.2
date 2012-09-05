Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2IEQdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:33:43 -0400
Received: from masquerade.micron.com ([137.201.242.130]:41615 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2IEQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:33:42 -0400
Message-ID: <50477EDC.4030206@micron.com>
Date: Wed, 5 Sep 2012 22:03:32 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 4/6] mtip32xx: Proper reporting of write protect status on
 big-endian
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No-13.444400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proper reporting of write protect status on big-endian

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index cf557a4..06bc273 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3218,8 +3218,8 @@ static int mtip_hw_init(struct driver_data *dd)
 				"Unable to check write protect progress\n");
 	else
 		dev_info(&dd->pdev->dev,
-				"Write protect progress: %d%% (%d blocks)\n",
-				attr242.cur, attr242.data);
+				"Write protect progress: %u%% (%u blocks)\n",
+				attr242.cur, le32_to_cpu(attr242.data));
 	return rv;
 
 out3:
-- 
1.7.1

