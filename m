Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2AZOHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:07:09 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7891 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2AZOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:07:08 -0500
X-IronPort-AV: E=Sophos;i="4.71,574,1320620400"; 
   d="scan'208";a="141542968"
Date: Thu, 26 Jan 2012 15:07:06 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing
 iounmap
In-Reply-To: <20120126135135.GD2611@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1201261504200.1851@localhost6.localdomain6>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126110506.GB2611@pengutronix.de> <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6> <20120126112242.GA9401@opensource.wolfsonmicro.com> <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
 <20120126135135.GD2611@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012, Wolfram Sang wrote:

> Julia,
>
>>  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> @@ -663,18 +663,11 @@ static int mxs_saif_probe(struct platform_device *pdev)
>>  		goto failed_get_resource;
>>  	}
>>
>> -	if (!request_mem_region(iores->start, resource_size(iores),
>> -				"mxs-saif")) {
>> -		dev_err(&pdev->dev, "request_mem_region failed\n");
>> -		ret = -EBUSY;
>> -		goto failed_get_resource;
>> -	}
>> -
>> -	saif->base = ioremap(iores->start, resource_size(iores));
>> +	saif->base = devm_request_and_ioremap(&pdev->dev, iores);
>
> You can skip checking 'iores', too. I also did that in the example, but
> a lot of people seem to miss it.

I can try to do that, but it seems a little bit unintuitive.  Perhaps it 
would be easier for people to remember to put in error handling code when 
they need it if they always have to do it?  If I remove it, there will be 
one call that has no test and then another call a few lines later that 
does.

> Where did you get the information how
> to use devm_request_and_ioremap? I probably need to spread the word even
> more...

I saw it in Documentation/driver-model/devres.txt and then looked around 
for some examples.

julia
