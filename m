Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1JWQ0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:26:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52576 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1JWQ0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <1732355.g0uNX7XlKI@donald.sf-tec.de>
References: <1319346300-18151-1-git-send-email-paul.s.schilling@gmail.com>
	<1732355.g0uNX7XlKI@donald.sf-tec.de>
Date: Sun, 23 Oct 2011 11:26:04 -0500
Message-ID: <CAC=G6szPCgSDB_1te3wZx2GGBiHMXMuQBQznSfjy2n1GtfCPxA@mail.gmail.com>
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, That was a good catch.  I had that extra struct for another
revision of the RDC peripheral integrated into the
Vortex86DX.  I removed it when I moved it to the pata_rdc.c driver but
forgot the struct.  The it821x driver works
for the RDC drivers when DMA is turned off.  But the RDC driver is the
more logical choice.

I will make the fix and send out the new patch.

I accidentally sent this through the gmail interface with html on,
Some of you may get this email twice.

Thanks,
Paul Schilling

On Sun, Oct 23, 2011 at 3:20 AM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>
> Paul Schilling wrote:
> > This fixes a DMA issue related to a CRC bug on
> > the RDC pata peripherial found on the vortex86sx and vortex86dx.
> >
> > Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
> > ---
> >  drivers/ata/pata_it821x.c |   22 ++++++++++++++++++----
> >  drivers/ata/pata_rdc.c    |   29 ++++++++++++++++++++++++-----
> >  drivers/ide/it821x.c      |    9 +++++++--
> >  include/linux/pci_ids.h   |    2 ++
> >  4 files changed, 51 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
> > index c5532b9..5f8a54a 100644
> > --- a/drivers/ata/pata_it821x.c
> > +++ b/drivers/ata/pata_it821x.c
> > @@ -897,7 +897,16 @@ static int it821x_init_one(struct pci_dev *pdev, const
> > struct pci_device_id *id) static const struct ata_port_info info_rdc_11 = {
> >               .flags = ATA_FLAG_SLAVE_POSS,
> >               .pio_mask = ATA_PIO4,
> > -             .mwdma_mask = ATA_MWDMA2,
> > +             .mwdma_mask = 0,
> > +             .udma_mask = 0,
> > +             /* No UDMA */
> > +             .port_ops = &it821x_rdc_port_ops
> > +     };
> > +     static const struct ata_port_info info_rdc_01 = {
> > +             .flags = ATA_FLAG_SLAVE_POSS,
> > +             .pio_mask = ATA_PIO4,
> > +             .mwdma_mask = 0,
> > +             .udma_mask = 0,
> >               /* No UDMA */
> >               .port_ops = &it821x_rdc_port_ops
> >       };
>
> Why do you define this if it is never used?
>
> Eike
