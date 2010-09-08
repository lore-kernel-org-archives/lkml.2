Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0IHQAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:00:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49172 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0IHQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:00:37 -0400
Date: Wed, 8 Sep 2010 10:00:34 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi/spi_s3c64xx: Increase dead reckoning time in
 wait_for_xfer()
Message-ID: <20100908160034.GB3686@angua.secretlab.ca>
References: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1283873872-8633-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTimxXWjiX64wJcNui2mLrvVg9RUtN9fFVnLhZsBY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimxXWjiX64wJcNui2mLrvVg9RUtN9fFVnLhZsBY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:44:26AM +0900, Jassi Brar wrote:
> On Wed, Sep 8, 2010 at 12:37 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > For small transfers at high speeds the expected transfer time can easily
> > be well under 1ms, causing the delay in wait_for_xfer() to be only the
> > dead reckoning fudge factor of 5ms currently included. Experiments on
> > some of my systems shows that this is marginal for some transfers so
> > double it to 10ms.
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/spi/spi_s3c64xx.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> > index 03b28e4..4abb441 100644
> > --- a/drivers/spi/spi_s3c64xx.c
> > +++ b/drivers/spi/spi_s3c64xx.c
> > @@ -326,7 +326,7 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
> >
> >        /* millisecs to xfer 'len' bytes @ 'cur_speed' */
> >        ms = xfer->len * 8 * 1000 / sdd->cur_speed;
> > -       ms += 5; /* some tolerance */
> > +       ms += 10; /* some tolerance */
> >
> >        if (dma_mode) {
> >                val = msecs_to_jiffies(ms) + 10;
> 
> Acked-by: Jassi Brar <jassi.brar@samsung.com>

Applied, thanks.

g.
