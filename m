Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab0HXXDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:09 -0400
Received: from kroah.org ([198.145.64.141]:41246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933563Ab0HXXDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:01 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.670156962@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marek.vasut@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [074/114] gen_nand: Test if nr_chips field is valid
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit 01cd2ababddd55a127caa1cd20d570637e0d42e1 upstream.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/plat_nand.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -37,6 +37,11 @@ static int __devinit plat_nand_probe(str
 	struct resource *res;
 	int err = 0;
 
+	if (pdata->chip.nr_chips < 1) {
+		dev_err(&pdev->dev, "invalid number of chips specified\n");
+		return -EINVAL;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;


