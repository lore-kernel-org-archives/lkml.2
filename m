Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2LSBlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:41:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:15837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab2LSBlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="259400943"
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
From: Jun Chen <jun.d.chen@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Bi Chao <chao.bi@intel.com>, spi-devel-general@lists.sourceforge.net
In-Reply-To: <20121218152623.GA26077@sirena.org.uk>
References: <1355848174.1435.25.camel@chenjun-workstation>
	 <20121218152623.GA26077@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 04:44:03 -0500
Message-ID: <1355910243.1435.39.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 15:26 +0000, Mark Brown wrote:
> On Tue, Dec 18, 2012 at 11:29:34AM -0500, Jun Chen wrote:
> 
> >   * @master: Controller to which device is connected
> > + * device_was_children_of_master is flag which the device is registed
> > + * as the children of the bus
> 
> This isn't a kerneldoc style comment (it needs the @XXX: format).  The
> name is also extremely long, can't we think of something more concise?
> 
Thank for your suggestion, I will correct this comment and use concise
flag.

> > -	spi->dev.parent = &master->dev;
> > +	if (device_was_children_of_master == true)
> > +		spi->dev.parent = &master->dev;
> > +	else
> > +		spi->dev.parent = dev;
> 
> Can you provide an example of where this is useful?  Your changelog
> didn't make it clear and the code doesn't make it obvious either.

This spi_alloc_device function will be called in the spi_new_device
function to alloc new device as the master. But other way, it is called
by the of_register_spi_devices function to register new device as the
children of the master. I will update changlog to add it. 

@@ -434,7 +440,7 @@ struct spi_device *spi_new_device(struct spi_master
*master,
         * suggests syslogged diagnostics are best here (ugh).
         */
 
-       proxy = spi_alloc_device(master);
+       proxy = spi_alloc_device(master, false);
        if (!proxy)
                return NULL;
 
@@ -827,7 +833,7 @@ static void of_register_spi_devices(struct
spi_master *master)
 
        for_each_available_child_of_node(master->dev.of_node, nc) {
                /* Alloc an spi_device */
-               spi = spi_alloc_device(master);
+               spi = spi_alloc_device(master, true);


If I have mistake, pls correct me, thanks!



