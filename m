Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2AZL2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:28:53 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:33715
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab2AZL2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:28:52 -0500
X-IronPort-AV: E=Sophos;i="4.71,573,1320620400"; 
   d="scan'208";a="128933452"
Date: Thu, 26 Jan 2012 12:28:51 +0100 (CET)
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
In-Reply-To: <20120126112508.GC2611@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1201261228350.1851@localhost6.localdomain6>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126110506.GB2611@pengutronix.de> <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6> <20120126112508.GC2611@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012, Wolfram Sang wrote:

> On Thu, Jan 26, 2012 at 12:21:35PM +0100, Julia Lawall wrote:
>> On Thu, 26 Jan 2012, Wolfram Sang wrote:
>>
>>>> @@ -666,18 +666,19 @@ static int mxs_saif_probe(struct platform_device *pdev)
>>>>  		goto failed_get_resource;
>>>>  	}
>>>>
>>>> -	if (!request_mem_region(iores->start, resource_size(iores),
>>>> -				"mxs-saif")) {
>>>> +	if (!devm_request_mem_region(&pdev->dev, iores->start,
>>>> +				     resource_size(iores), "mxs-saif")) {
>>>>  		dev_err(&pdev->dev, "request_mem_region failed\n");
>>>>  		ret = -EBUSY;
>>>>  		goto failed_get_resource;
>>>>  	}
>>>>
>>>> -	saif->base = ioremap(iores->start, resource_size(iores));
>>>> +	saif->base = devm_ioremap(&pdev->dev, iores->start,
>>>> +				  resource_size(iores));
>>>
>>> devm_request_and_ioremap() to save even more code?
>>
>> I didn't do that because apparently it is not yet in a release?  I
>> have another for introducing those...
>
> It got included in the last merge window:
>
> commit 72f8c0bfa0de64c68ee59f40eb9b2683bffffbb0
> Author: Wolfram Sang <w.sang@pengutronix.de>
> Date:   Tue Oct 25 15:16:47 2011 +0200
>
>    lib: devres: add convenience function to remap a resource
> ...

OK, thanks.  I'll take that into account.

julia
