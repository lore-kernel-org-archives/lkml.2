Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935866Ab2JYQNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:13:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:56825
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946255Ab2JYQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 10
X-BigFish: VS10(zzb460rzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <festevam@gmail.com>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regmap: Fix printing of size_t variable
Date: Thu, 25 Oct 2012 14:07:18 -0200
Message-ID: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val_bytes is of 'size_t', so it should be printed as '%zu'.

Fixes the following build warning on x86:

drivers/base/regmap/regmap.c:872:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0585726..cc90dfc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -869,7 +869,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 		/* If the write goes beyond the end of the window split it */
 		while (val_num > win_residue) {
-			dev_dbg(map->dev, "Writing window %d/%d\n",
+			dev_dbg(map->dev, "Writing window %d/%zu\n",
 				win_residue, val_len / map->format.val_bytes);
 			ret = _regmap_raw_write(map, reg, val, win_residue *
 						map->format.val_bytes);
-- 
1.7.9.5


