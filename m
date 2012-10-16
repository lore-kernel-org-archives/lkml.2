Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2JPUa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:30:27 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:44399 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752251Ab2JPUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:30:24 -0400
Message-ID: <507DC3DA.3030403@xenotime.net>
Date: Tue, 16 Oct 2012 13:30:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] regmap: fix regmap.c printk format warning
References: <20121016145856.cfddc9c898c31b1c686804d7@canb.auug.org.au>
In-Reply-To: <20121016145856.cfddc9c898c31b1c686804d7@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning (found on x86_64):

drivers/base/regmap/regmap.c:861:4: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121016.orig/drivers/base/regmap/regmap.c
+++ linux-next-20121016/drivers/base/regmap/regmap.c
@@ -858,7 +858,7 @@ static int _regmap_raw_write(struct regm
 
 		/* If the write goes beyond the end of the window split it */
 		while (val_num > win_residue) {
-			dev_dbg(map->dev, "Writing window %d/%d\n",
+			dev_dbg(map->dev, "Writing window %d/%zu\n",
 				win_residue, val_len / map->format.val_bytes);
 			ret = _regmap_raw_write(map, reg, val, win_residue *
 						map->format.val_bytes);
