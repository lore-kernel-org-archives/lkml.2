Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2EGIZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:25:34 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:57047 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2EGIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:25:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgLAIWFp09bdWOb/2dsb2JhbABEhXKkbyKHbYEHggwBAQUjBFIQCxgCAiYCAlcGiCWndZIFgS+OWIEYBKZAgms
X-IronPort-AV: E=Sophos;i="4.75,543,1330902000"; 
   d="scan'208";a="987295407"
Message-ID: <1336379095.2852.17.camel@fourier.local.igalia.com>
Subject: Re: [PATCH v2 1/3] Staging: IndustryPack bus for the Linux Kernel
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 10:24:55 +0200
In-Reply-To: <20120507080458.GN22134@mwanda>
References: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
	 <20120507080458.GN22134@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 11:04 +0300, Dan Carpenter wrote:
> 
> [snip]
> 
> > +int ipack_device_find_drv(struct device_driver *driver, void *param)
> > +{
> > +	int ret;
> > +	struct ipack_device *dev = (struct ipack_device *)param;
> > +
> > +	ret = ipack_bus_match(&dev->dev, driver);
> > +	if (ret)
> > +		return !ipack_bus_probe(&dev->dev);
> 
> Wouldn't probe() return zero or a negative error code?

Yes. However, in case of the function called by bus_for_each_drv(), it
should return zero if you want to continue or nonzero value to stop the
iteration.

I considered that if the probe fails, we can try with the next driver in
the list. So, the returned value of probe() is negated.

I will fix the other things and send it again with other suggestions. 

Thanks,

Sam

