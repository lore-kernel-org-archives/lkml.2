Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2GaMca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:32:30 -0400
Received: from smtp-out-178.synserver.de ([212.40.185.178]:1092 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2GaMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:32:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23246
Message-ID: <5017D148.6030006@metafoo.de>
Date: Tue, 31 Jul 2012 14:36:24 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/31/2012 12:09 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> @@ -720,20 +698,14 @@ error_ret:
>  static int __devexit at91_adc_remove(struct platform_device *pdev)
>  {
>  	struct iio_dev *idev = platform_get_drvdata(pdev);
> -	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	struct at91_adc_state *st = iio_priv(idev);
>  
>  	iio_device_unregister(idev);
> [...]
> -	free_irq(st->irq, idev);
> [...]
>  	iio_device_free(idev);

I think we have to be careful here. The interrupted is now freed after the
device has been freed, which means that it could trigger after the device
has been freed. And since we use the device in the interrupt handler we'll
get a use after free.

- Lars
