Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0LSQyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:54:24 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36224 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab0LSQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nEnjeFy0KzMq67JyBqhpTvjKfoBshxFhMDWZl/PNmKu2GzhAWJQa1trZHbc72cRkXB
         UnN118PXzYtuJKR4qmJBgwvmup3x3Vd9g13a0bnJ2kxyPqlh9al0+cJ0p88QIFwP5H2/
         OQCPuD//p1ur0By6wYJi8zpOV9taq8s2ibGGM=
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <liu.h.jason@gmail.com>
Cc: Jason Liu <r64343@freescale.com>, David.Woodhouse@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=zB7UBjkvGYv_wdwZpH1Ghatn6eye1z5616h4X@mail.gmail.com>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
	 <1292340409.2538.40.camel@localhost>
	 <AANLkTi=zB7UBjkvGYv_wdwZpH1Ghatn6eye1z5616h4X@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 18:54:05 +0200
Message-ID: <1292777645.13362.3.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 09:55 +0800, Jason Liu wrote:
> >        /* Do not allow reads past end of device */
> >        if (unlikely(from >= mtd->size ||
> >                     ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
> >                                        (from >> chip->page_shift)) * len)) {
> >                DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt read beyond end "
> >                                        "of device\n", __func__);
> >                return -EINVAL;
> >        }
> 
> Here the mtd->size in nand_base.c should be the NAND flash chip size,

I think this is partition size as well.

> while in nand_oobtest,
> 
>               /* Attempt to read off end of device */
>                 ops.mode      = MTD_OOB_AUTO;
>                 ops.len       = 0;
>                 ops.retlen    = 0;
>                 ops.ooblen    = mtd->ecclayout->oobavail;
>                 ops.oobretlen = 0;
>                 ops.ooboffs   = 1;
>                 ops.datbuf    = NULL;
>                 ops.oobbuf    = readbuf;
>                 printk(PRINT_PREF "attempting to read past end of device\n");
>                 printk(PRINT_PREF "an error is expected...\n");
>                 err = mtd->read_oob(mtd, mtd->size - mtd->writesize, &ops);
>                 if (err) {
>                         printk(PRINT_PREF "error occurred as expected\n");
>                         err = 0;
>                 } else {
>                         printk(PRINT_PREF "error: read past end of device\n");
>                         errcnt += 1;
>                 }
>         }
> 
> here, mtd->size is mtd partition size right? when the mtd partition is
> not the last MTD partition, the error will happen.

I think this is the same in both. Try to debug this with printks().

> 
> I have tested on real NAND, while not on nandsim.

Please, try to reproduce this with nandsim as well, and if it works, try
to find out why (using printk debugging)

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

