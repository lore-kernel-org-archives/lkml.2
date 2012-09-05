Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab2IEQe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:34:27 -0400
Received: from masquerade.micron.com ([137.201.242.130]:61634 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2IEQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:34:25 -0400
Message-ID: <50477F08.4040406@micron.com>
Date: Wed, 5 Sep 2012 22:04:16 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 6/6] mtip32xx: Remove dead code
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No-5.555200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the dead code in mtip_hw_read_registers() and mtip_hw_read_flags().

Reported-by: Coverity
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 362ce4a..e6519e2 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2592,9 +2592,6 @@ static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
 	if (!len || size)
 		return 0;
 
-	if (size < 0)
-		return -EINVAL;
-
 	size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
 
 	for (n = dd->slot_groups-1; n >= 0; n--)
@@ -2664,9 +2661,6 @@ static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
 	if (!len || size)
 		return 0;
 
-	if (size < 0)
-		return -EINVAL;
-
 	size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
 							dd->port->flags);
 	size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
-- 
1.7.1

