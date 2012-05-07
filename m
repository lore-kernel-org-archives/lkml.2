Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2EGOYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:24:42 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:40526 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2EGOYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:24:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQJAOXZp09bdWOb/2dsb2JhbABEhXKkdSKIEIEHggwBAQUjBFIQCxgCAiYCAlcGiCWoOpI3gS+OWIEYBKZAgms
X-IronPort-AV: E=Sophos;i="4.75,544,1330902000"; 
   d="scan'208";a="511826000"
Message-ID: <1336400676.12407.10.camel@fourier.local.igalia.com>
Subject: Re: [PATCH v2 1/3] Staging: IndustryPack bus for the Linux Kernel
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 16:24:36 +0200
In-Reply-To: <1336379095.2852.17.camel@fourier.local.igalia.com>
References: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
	 <20120507080458.GN22134@mwanda>
	 <1336379095.2852.17.camel@fourier.local.igalia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:24 +0200, Samuel Iglesias Gonsálvez wrote:
> On Mon, 2012-05-07 at 11:04 +0300, Dan Carpenter wrote:
> > 
> > [snip]
> > 
> > > +int ipack_device_find_drv(struct device_driver *driver, void *param)
> > > +{
> > > +	int ret;
> > > +	struct ipack_device *dev = (struct ipack_device *)param;
> > > +
> > > +	ret = ipack_bus_match(&dev->dev, driver);
> > > +	if (ret)
> > > +		return !ipack_bus_probe(&dev->dev);
> > 
> > Wouldn't probe() return zero or a negative error code?
> 
> Yes. However, in case of the function called by bus_for_each_drv(), it
> should return zero if you want to continue or nonzero value to stop the
> iteration.
> 
> I considered that if the probe fails, we can try with the next driver in
> the list. So, the returned value of probe() is negated.

Checking the device_register() function, it actually does the same I am
trying to do here: call the bus' match() function with each driver
registered on the bus searching which one can manage the device, and
then call the probe().

So I can delete this function safely and bus_for_each_drv() in
ipack_device_register().

Thanks,

Sam

