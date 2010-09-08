Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0IHSX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:23:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63196 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0IHSXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:23:25 -0400
Date: Wed, 8 Sep 2010 12:23:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH] spi/spi_s3c64xx: Warn if PIO
 transfers time out
Message-ID: <20100908182315.GR3686@angua.secretlab.ca>
References: <1282581656-26137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTim6+6-L8ALM0YO01D44PmZgsbcMrrwRxrPJMkpT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim6+6-L8ALM0YO01D44PmZgsbcMrrwRxrPJMkpT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:06:40AM +0900, Jassi Brar wrote:
> On Tue, Aug 24, 2010 at 1:40 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > When using PIO we have a timeout for the TX and RX FIFOs to ensure that
> > the data actually gets transferred. Warn if we hit that timeout - it
> > should never happen, but this makes sure we'll find out if it does.
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/spi/spi_s3c64xx.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> > index 7e627f7..f72e1c0 100644
> > --- a/drivers/spi/spi_s3c64xx.c
> > +++ b/drivers/spi/spi_s3c64xx.c
> > @@ -200,6 +200,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
> >                val = readl(regs + S3C64XX_SPI_STATUS);
> >        } while (TX_FIFO_LVL(val, sci) && loops--);
> >
> > +       if (loops == 0)
> > +               dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
> > +
> >        /* Flush RxFIFO*/
> >        loops = msecs_to_loops(1);
> >        do {
> > @@ -210,6 +213,9 @@ static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
> >                        break;
> >        } while (loops--);
> >
> > +       if (loops == 0)
> > +               dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
> > +
> >        val = readl(regs + S3C64XX_SPI_CH_CFG);
> >        val &= ~S3C64XX_SPI_CH_SW_RST;
> >        writel(val, regs + S3C64XX_SPI_CH_CFG);
> 
> Ok, though I'll be very surprised to see the FIFO flush failing. We
> are not waiting
> for data to be transferred, but for SW Reset to make its effect.
> 
> Acked-by: Jassi Brar <jassi.brar@samsung.com>

Applied, thanks.

g.

