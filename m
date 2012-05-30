Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2E3Bpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:45:39 -0400
Received: from masquerade.micron.com ([137.201.242.130]:46298 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2E3Bph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:45:37 -0400
Message-ID: <4FC57BBF.2090605@micron.com>
Date: Tue, 29 May 2012 18:45:35 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 11/11] mtip32xx: Change disk capacity unit from MB to MiB
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--6.379900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disk capacity is calculated as power of 2, but displayed as MB. Change the
unit to MiB.

Reported-by: Robert Elliott <Elliott@hp.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 18daa04..411276d 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1759,7 +1759,7 @@ static void mtip_dump_identify(struct mtip_port *port)
 
 	if (mtip_hw_get_capacity(port->dd, &sectors))
 		dev_info(&port->dd->pdev->dev,
-			"Capacity: %llu sectors (%llu MB)\n",
+			"Capacity: %llu sectors (%llu MiB)\n",
 			 (u64)sectors,
 			 ((u64)sectors) * ATA_SECT_SIZE >> 20);
 
-- 
1.7.1

