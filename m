Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2E3BoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:44:06 -0400
Received: from masquerade.micron.com ([137.201.242.130]:15511 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab2E3BoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:44:04 -0400
Message-ID: <4FC57B61.5020004@micron.com>
Date: Tue, 29 May 2012 18:44:01 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 08/11] mtip32xx: minor performance tweak
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--4.642100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When checking for command completions if the register value is zero, proceed
to next register.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index acc1d6f..d0fa357 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -970,6 +970,8 @@ static inline void mtip_process_sdbf(struct driver_data *dd)
 	/* walk all bits in all slot groups */
 	for (group = 0; group < dd->slot_groups; group++) {
 		completed = readl(port->completed[group]);
+		if (!completed)
+			continue;
 
 		/* clear completed status register in the hardware.*/
 		writel(completed, port->completed[group]);
-- 
1.7.1

