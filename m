Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2A1Ivu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 03:51:50 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:60808
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953Ab2A1Ivt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 03:51:49 -0500
X-IronPort-AV: E=Sophos;i="4.71,584,1320620400"; 
   d="scan'208";a="129200318"
Date: Sat, 28 Jan 2012 09:51:46 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
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
In-Reply-To: <20120128082630.GA2509@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1201280950120.2045@hadrien>
References: <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com> <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de> <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6> <20120126112242.GA9401@opensource.wolfsonmicro.com> <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6> <20120126135135.GD2611@pengutronix.de>
 <alpine.DEB.2.02.1201261504200.1851@localhost6.localdomain6> <20120128082630.GA2509@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jan 2012, Wolfram Sang wrote:

>>> You can skip checking 'iores', too. I also did that in the example, but
>>> a lot of people seem to miss it.
>>
>> I can try to do that, but it seems a little bit unintuitive.
>> Perhaps it would be easier for people to remember to put in error
>> handling code when they need it if they always have to do it?  If I
>> remove it, there will be one call that has no test and then another
>> call a few lines later that does.
>
> I see your point. I would still like to get rid of the duplicated code
> (then it can't be forgotten as well). Maybe I should have named the
> function something alike devm_check_and_request_and_ioremap()? Then I
> could have also introduced a similar function for requesting irq. Will
> think about this a bit more. Thanks for updating your patch!

Despite believing in my point, error handling code is where people make a 
lot of mistakes.  Getting rid of it seems always to be a good idea.  Maybe 
such checks could be moved into more uses of the result of 
platform_get_resource.

julia
