Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1GOEjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:39:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33835 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080Ab1GOEje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:39:34 -0400
Date: Fri, 15 Jul 2011 13:39:25 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
Message-ID: <20110715043922.GJ32716@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025327.GI2927@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715025327.GI2927@ponder.secretlab.ca>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 08:53:27PM -0600, Grant Likely wrote:
> On Sat, Jul 09, 2011 at 01:50:43PM +0900, Mark Brown wrote:

> >  obj-$(CONFIG_I2C) += regmap-i2c.o
> > +obj-$(CONFIG_SPI) += regmap-spi.o

> I would think this code should live with drivers/spi.c  And similar
> for the i2c implementation.

There was a bit about this in the cover mail - it's the interace
stability issue again, the plan is to move them once we're more
confident that the interface used will stay stable.

> > +{
> > +	struct spi_device *spi = to_spi_device(dev);
> > +	struct spi_message m;
> > +	struct spi_transfer t[2];

> > +	spi_message_init(&m);
> > +
> > +	memset(&t, 0, sizeof(t));

> If you do:

> 	struct spi_transfer t[2] = { {.tx_buf = reg, .len = reg_len},
> 				     {.tx_buf = val, .len = val_len}};

> Then the memset() and t[0]/t[1] lines can all be culled.

That does the init to zero?

> > +	t[1].tx_buf = val;
> > +	t[1].len = val_len;
> > +	spi_message_add_tail(&t[0], &m);

> t[0]?

Yes, that's been fixed in git for a little while now.
