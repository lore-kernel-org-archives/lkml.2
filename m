Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2EKRcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:32:24 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47523 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2EKRcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:32:22 -0400
Message-ID: <4FAD4D20.1010302@mev.co.uk>
Date: Fri, 11 May 2012 18:32:16 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
References: <201205111007.46754.hartleys@visionengravers.com>
In-Reply-To: <201205111007.46754.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-11 18:07, H Hartley Sweeten wrote:
> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
> +		struct pci_driver *pci_driver)
> +{
> +	int ret;
> +
> +	ret = comedi_driver_register(comedi_driver);
> +	if (ret<  0)
> +		return ret;
> +
> +	pci_driver->name = comedi_driver->driver_name;

I think it would be better if the driver modules that call this function 
already had pci_driver->name initialized statically.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
