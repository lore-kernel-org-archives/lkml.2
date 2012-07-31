Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2GaMlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:41:46 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52583 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab2GaMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:41:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,686,1336341600"; 
   d="scan'208";a="168673952"
Date: Tue, 31 Jul 2012 14:41:42 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
In-Reply-To: <5017D148.6030006@metafoo.de>
Message-ID: <alpine.DEB.2.02.1207311435040.1894@hadrien>
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr> <5017D148.6030006@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Lars-Peter Clausen wrote:

> Hi,
>
> On 07/31/2012 12:09 PM, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > @@ -720,20 +698,14 @@ error_ret:
> >  static int __devexit at91_adc_remove(struct platform_device *pdev)
> >  {
> >  	struct iio_dev *idev = platform_get_drvdata(pdev);
> > -	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	struct at91_adc_state *st = iio_priv(idev);
> >
> >  	iio_device_unregister(idev);
> > [...]
> > -	free_irq(st->irq, idev);
> > [...]
> >  	iio_device_free(idev);
>
> I think we have to be careful here. The interrupted is now freed after the
> device has been freed, which means that it could trigger after the device
> has been freed. And since we use the device in the interrupt handler we'll
> get a use after free.

OK, thanks for the feedback.  I'll try again, and un-devm_ this function.

julia
