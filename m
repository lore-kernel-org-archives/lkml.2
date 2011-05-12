Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1ELHQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:16:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37480 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1ELHQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G9U8ADX9ezmVnL/BPSIwCpxXMdhRx6lYsjQs5I6I6pMkV8ggSl6NnZU4kNrVNivjZO
         1R3NWI079gDHccNTPIhDN0jFFg1EA5GlKYLRbIM90RgYOVWWkbmEXoQ81ksCTa6+sj6Q
         D5PeZ5AR37eZc4gurH6VeO8dCCFDFQ2n2l7X4=
MIME-Version: 1.0
In-Reply-To: <BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	<20110511183322.da0739c9.akpm@linux-foundation.org>
	<BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
	<BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
Date: Thu, 12 May 2011 02:16:07 -0500
Message-ID: <BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>
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

Why isn't my patch going through? re-sending again,

Signed-off-by: Nitin Garg <nitingarg98@xxxxxxxx>
---
 drivers/mtd/nand/nand_base.c |    2 +-
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
-	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;
+	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
le32_to_cpu(p->lun_count) * mtd->erasesize;
 	busw = 0;
 	if (le16_to_cpu(p->features) & 1)
 		busw = NAND_BUSWIDTH_16;
-- 
1.5.5.6



On Thu, May 12, 2011 at 2:05 AM, Nitin Garg <nitingarg98@gmail.com> wrote:
> Here is the tested patch, pls apply.
>
> From 1a73f1c3d066a491d0c806883788ab9abdc736f3 Mon Sep 17 00:00:00 2001
> From: Nitin Garg <nitingarg98@gmail.com>
> Date: Thu, 12 May 2011 01:31:53 -0500
> Subject: [PATCH] Fix ONFI NAND flash size detection by using number of
> Logical Units in device
>
> Signed-off-by: Nitin Garg <nitingarg98@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index c54a4cb..cdf6015 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
> mtd_info *mtd, struct nand_chip *chip,
>        mtd->writesize = le32_to_cpu(p->byte_per_page);
>        mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
>        mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
> -       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
> mtd->erasesize;
> +       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
> le32_to_cpu(p->lun_count) * mtd->erasesize;
>        busw = 0;
>        if (le16_to_cpu(p->features) & 1)
>                busw = NAND_BUSWIDTH_16;
> --
> 1.5.5.6
>
