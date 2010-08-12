Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0HLAWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:22:12 -0400
Received: from kroah.org ([198.145.64.141]:60315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759589Ab0HLAEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:35 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.240251608@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marek.vasut@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [43/54] mtd: gen_nand: fix support for multiple chips
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit 81cbb0b17796d81cbd92defe113cf2a7c7a21fbb upstream.

This patch corrects a problem where gen_nand driver assumed there can be only
one chip and ignored the pdata->chip.nr_chips value.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/plat_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -91,7 +91,7 @@ static int __devinit plat_nand_probe(str
 	}
 
 	/* Scan to find existance of the device */
-	if (nand_scan(&data->mtd, 1)) {
+	if (nand_scan(&data->mtd, pdata->chip.nr_chips)) {
 		err = -ENXIO;
 		goto out;
 	}


