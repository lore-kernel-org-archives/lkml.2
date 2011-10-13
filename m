Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1JMH3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:29:44 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:62856 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1JMH3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:29:43 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 03:29:42 EDT
From: <akira2.iguchi@toshiba.co.jp>
To: <bzolnier@gmail.com>, <alan@lxorguk.ukuu.org.uk>
CC: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kou.ishizaki@toshiba.co.jp>
Subject: RE: [PATCH] pata_scc: add proper cable detection method
Thread-Topic: [PATCH] pata_scc: add proper cable detection method
Thread-Index: AQHMiPOoFI5m7LHg+02wdIxUYWybB5V53akQ
Date: Thu, 13 Oct 2011 07:23:19 +0000
Message-ID: <0AD1ABF616D7584184961C46C6BECD283C156EEA@TGXML215.toshiba.local>
References: <201110112007.24530.bzolnier@gmail.com>
 <20111011205415.1d5708af@lxorguk.ukuu.org.uk>
 <201110121716.37990.bzolnier@gmail.com>
In-Reply-To: <201110121716.37990.bzolnier@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
x-originating-ip: [133.118.185.131]
msscp.transfermailtomossagent: 103
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for maintaining our code.
This patch makes no difference in functionality.

Acked-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Acked-by: Akira Iguchi <akira2.iguchi@toshiba.co.jp>

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:bzolnier@gmail.com]
> Sent: Thursday, October 13, 2011 12:17 AM
> To: Alan Cox
> Cc: Jeff Garzik; linux-ide@vger.kernel.org;
> linux-kernel@vger.kernel.org; ishizaki ko(石崎 浩 ○府□放Ｎブ○放送
> 機); iguchi akira(井口 晃 ○Ｌジ□ＬＳ開○ＬＳ二)
> Subject: Re: [PATCH] pata_scc: add proper cable detection method
> 
> Alan Cox wrote:
> 
> > On Tue, 11 Oct 2011 20:07:24 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] pata_scc: add proper cable detection method
> > >
> > > Use standard ata_cable_80wire() method for the cable detection, as a
> > > bonus this allows us to use the default ->prereset method.
> >
> > What documentation have you got that confirms that the hardcoding is
> > not needed. It goes back to the original code and I see nothing saying
> > that the device has standard PC style cable detect.
> 
> The driver predates standard cable detect routines and open-codes its own
> one.  There should be no functionality changes caused by this patch.
> 
> Commit a619f981b ("libata: PATA driver for Celleb") is from Jan 2007 while
> ata_cable_80wire() was added by commit be0d18d ("libata: cable detection
> fixes") in Mar 2007.
> 
> > You should also I think cc the Toshiba maintainers
> 
> added to cc:.
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_scc: add proper cable detection method
> 
> Use standard ata_cable_80wire() method for the cable detection, as a bonus
> this allows us to use the default ->prereset method.
> 
> Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
> Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> earlier references:
> https://lkml.org/lkml/2009/11/25/373
> 
>  drivers/ata/pata_scc.c |   14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> Index: b/drivers/ata/pata_scc.c
> ===================================================================
> --- a/drivers/ata/pata_scc.c
> +++ b/drivers/ata/pata_scc.c
> @@ -827,18 +827,6 @@ static unsigned int scc_data_xfer (struc  }
> 
>  /**
> - *	scc_pata_prereset - prepare for reset
> - *	@ap: ATA port to be reset
> - *	@deadline: deadline jiffies for the operation
> - */
> -
> -static int scc_pata_prereset(struct ata_link *link, unsigned long
> deadline) -{
> -	link->ap->cbl = ATA_CBL_PATA80;
> -	return ata_sff_prereset(link, deadline);
> -}
> -
> -/**
>   *	scc_postreset - standard postreset callback
>   *	@ap: the target ata_port
>   *	@classes: classes of attached devices
> @@ -947,7 +935,7 @@ static struct ata_port_operations scc_pa
>  	.bmdma_status		= scc_bmdma_status,
>  	.sff_data_xfer		= scc_data_xfer,
> 
> -	.prereset		= scc_pata_prereset,
> +	.cable_detect		= ata_cable_80wire,
>  	.softreset		= scc_softreset,
>  	.postreset		= scc_postreset,
> 
