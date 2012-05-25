Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2EYIhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:37:13 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17280 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201Ab2EYIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:37:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Fri, 25 May 2012 16:56:51 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marc Reilly <marc@cpdesign.com.au>
CC: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120525085649.GA8495@S2100-06.ap.freescale.net>
References: <201205221053.21792.marc@cpdesign.com.au>
 <20120524064635.GP3710@pengutronix.de>
 <20120524073315.GE7843@S2100-06.ap.freescale.net>
 <201205241908.38278.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201205241908.38278.marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:08:37PM +1000, Marc Reilly wrote:
> > diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> > index 3fcdab3..5d1969f 100644
> > --- a/drivers/mfd/mc13xxx-spi.c
> > +++ b/drivers/mfd/mc13xxx-spi.c
> > @@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
> >         .reg_bits = 7,
> >         .pad_bits = 1,
> >         .val_bits = 24,
> > +       .write_flag_mask = 0x80,
> 
> Should probably have .read_flag_mask = 0x00, here too. If either are non zero, 
> both are set.
> 
Since mc13xxx_regmap_spi_config is a static variable, .read_flag_mask
is initialized as 0 already.

> I guess this is the problem, regmap's default read_flag_mask for the spi bus 
> is 0x80, and the write mask defaults to 0. The mc13xxx works the opposite way 
> though! aarg. My bad for not noticing. So setting the write_flag_mask to 0x80 
> also sets the read mask to 0 correctly also.

-- 
Regards,
Shawn

