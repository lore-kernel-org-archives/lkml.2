Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1ELHFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:05:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1ELHFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oftGfCPt/pKJLUbSEFfkO4IhMtW5lrcWppZpckx0ngSF63CAMt2/VV7jeCO7WLubid
         CF3OX8OLkVm2fZVHi4s+SutCpku80weH/XHhDAfpwmdDM+L/cYTmUcdeJ/ujrZJouTkh
         387AFfwUtaK8Ki73qxTRreBYKH/3/bPn83vMY=
MIME-Version: 1.0
In-Reply-To: <BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	<20110511183322.da0739c9.akpm@linux-foundation.org>
	<BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
Date: Thu, 12 May 2011 02:05:37 -0500
Message-ID: <BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Nitin Garg <nitingarg98@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the tested patch, pls apply.

>From 1a73f1c3d066a491d0c806883788ab9abdc736f3 Mon Sep 17 00:00:00 2001
From: Nitin Garg <nitingarg98@gmail.com>
Date: Thu, 12 May 2011 01:31:53 -0500
Subject: [PATCH] Fix ONFI NAND flash size detection by using number of
Logical Units in device

Signed-off-by: Nitin Garg <nitingarg98@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index c54a4cb..cdf6015 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
mtd_info *mtd, struct nand_chip *chip,
       mtd->writesize = le32_to_cpu(p->byte_per_page);
       mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
       mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
-       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
mtd->erasesize;
+       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
le32_to_cpu(p->lun_count) * mtd->erasesize;
       busw = 0;
       if (le16_to_cpu(p->features) & 1)
               busw = NAND_BUSWIDTH_16;
--
1.5.5.6
