Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1FGOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:55:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34362 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1FGOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lPqf9pbMCT88wigwnL45uQjaeu4moVZNuanDNkCIj3lvMaxUFn8en933dd56DfeeyH
         jP3v3rskMxkXctdVa28jKAylNp/lrgswXBgX7S+E8QZ+ybsMbu5I0NM7nzuvhlDF9xiA
         48TH/+tN1XlYi4dxGeooQb1c51pqA7q5Ek5Vw=
Subject: [PATCH] mtd: ndfc: fix a memory leak in ndfc_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Sean MacLennan <smaclennan@pikatech.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 22:55:21 +0800
Message-ID: <1307458521.22584.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/ndfc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index ea2dea8..7995470 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -288,6 +288,7 @@ static int __devexit ndfc_remove(struct platform_device *ofdev)
 	struct ndfc_controller *ndfc = dev_get_drvdata(&ofdev->dev);
 
 	nand_release(&ndfc->mtd);
+	kfree(ndfc->mtd.name);
 
 	return 0;
 }
-- 
1.7.4.1



