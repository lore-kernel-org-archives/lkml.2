Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1HJGMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:12:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59062 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1HJGMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:12:03 -0400
Date: Wed, 10 Aug 2011 08:11:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Jiandong Zheng <jdzheng@broadcom.com>, kernel-janitors@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/nand/bcm_umi_nand.c: add missing kfree/ioremap
In-Reply-To: <4E421EC7.6090505@gmail.com>
Message-ID: <Pine.LNX.4.64.1108100811170.22900@ask.diku.dk>
References: <1312954935-14592-1-git-send-email-julia@diku.dk>
 <4E421EC7.6090505@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011, Ryan Mallon wrote:

> On 10/08/11 15:42, Julia Lawall wrote:
> > From: Julia Lawall<julia@diku.dk>
> >
> > The error handling code under the #if should be the same as elsewhere in
> > the function.
> >
> > Signed-off-by: Julia Lawall<julia@diku.dk>
> >
> > ---
> >   drivers/mtd/nand/bcm_umi_nand.c |    5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mtd/nand/bcm_umi_nand.c
> > b/drivers/mtd/nand/bcm_umi_nand.c
> > index a8ae898..72e8ec2 100644
> > --- a/drivers/mtd/nand/bcm_umi_nand.c
> > +++ b/drivers/mtd/nand/bcm_umi_nand.c
> > @@ -433,8 +433,11 @@ static int __devinit bcm_umi_nand_probe(struct
> platform_device *pdev)
> >
> >   #if USE_DMA
> >   	err = nand_dma_init();
> > -	if (err != 0)
> > +	if (err != 0) {
> > +		iounmap(bcm_umi_io_base);
> > +		kfree(board_mtd);
> >   		return err;
> > +	}
> >   #endif
> 
> This probe function should possibly use goto exits on failure. It reduces a
> bit of code duplication and helps prevent this type of error.

OK, I didn't want to make such a major change for only one new case.  But 
since there are three new cases, I will do that.

julia
