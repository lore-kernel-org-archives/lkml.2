Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2AZL5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:57:10 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:16852 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2AZL5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:57:07 -0500
Message-ID: <4F213F90.8060007@bfs.de>
Date: Thu, 26 Jan 2012 12:57:04 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Julia Lawall <julia.lawall@lip6.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing
 iounmap
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com> <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126110506.GB2611@pengutronix.de>
In-Reply-To: <20120126110506.GB2611@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 26.01.2012 12:05, schrieb Wolfram Sang:
>> @@ -666,18 +666,19 @@ static int mxs_saif_probe(struct platform_device *pdev)
>>   		goto failed_get_resource;
>>   	}
>>
>> -	if (!request_mem_region(iores->start, resource_size(iores),
>> -				"mxs-saif")) {
>> +	if (!devm_request_mem_region(&pdev->dev, iores->start,
>> +				     resource_size(iores), "mxs-saif")) {
>>   		dev_err(&pdev->dev, "request_mem_region failed\n");
>>   		ret = -EBUSY;
>>   		goto failed_get_resource;
>>   	}
>>
>> -	saif->base = ioremap(iores->start, resource_size(iores));
>> +	saif->base = devm_ioremap(&pdev->dev, iores->start,
>> +				  resource_size(iores));
> 
> devm_request_and_ioremap() to save even more code?
> 

hi all,
at first I am NOT the maintainer ...

personally i would stay with Julia's patch and add devm_request_and_ioremap() in a second round.
The devm stuff is brand new, and two steps here would allow to spot/locate problems more easy
since structural changes are less intrusive in each step.

re,
 wh




