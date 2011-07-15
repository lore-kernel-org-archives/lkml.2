Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1GOEsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:48:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47185 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752084Ab1GOEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:48:23 -0400
Date: Fri, 15 Jul 2011 13:48:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715044800.GK32716@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025328.GJ2927@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715025328.GJ2927@ponder.secretlab.ca>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 08:53:28PM -0600, Grant Likely wrote:
> On Sat, Jul 09, 2011 at 01:50:44PM +0900, Mark Brown wrote:

> > -	mutex_init(&tps->io_lock);
> > +	tps->regmap = regmap_init(&client->dev, &tps65023_regmap_config);

> Yeah, if this usage is typical, the caller will always know exactly
> what kind of regmap it needs to set up because it had an i2c_client or
> an spi_device instance.  I think it would be better to drop the
> central registration of regmap bus types and use bus-specific init
> variant.  It just makes for one more bit of registration
> infrastructure that needs to be setup before any drivers us it.

Right, the driver is always going to know exactly what bus it registered
on but for many drivers we don't really have any bus-specific code once
we factor out the register I/O.
