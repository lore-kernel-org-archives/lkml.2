Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1BPAdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:33:05 -0500
Received: from kroah.org ([198.145.64.141]:49752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1BPAYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.685333636@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [236/272] mtd: pxa3xx_nand: NULL dereference in pxa3xx_nand_probe
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 52d039fdaa78c5a9f9bc2940ad58d7ed76b8336d upstream.

"info->cmdset" gets dereferenced in __readid() so it needs to be
initialized earlier in the function.  This bug was introduced in
18c81b1828f8 "mtd: pxa3xx_nand: remove the flash info in driver
structure".

Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/pxa3xx_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -885,6 +885,7 @@ static int pxa3xx_nand_detect_config(str
 	/* set info fields needed to __readid */
 	info->read_id_bytes = (info->page_size == 2048) ? 4 : 2;
 	info->reg_ndcr = ndcr;
+	info->cmdset = &default_cmdset;
 
 	if (__readid(info, &id))
 		return -ENODEV;
@@ -915,7 +916,6 @@ static int pxa3xx_nand_detect_config(str
 
 	info->ndtr0cs0 = nand_readl(info, NDTR0CS0);
 	info->ndtr1cs0 = nand_readl(info, NDTR1CS0);
-	info->cmdset = &default_cmdset;
 
 	return 0;
 }


