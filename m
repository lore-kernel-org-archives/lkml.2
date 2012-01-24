Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2AXUgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:36:21 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62349
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab2AXUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:36:20 -0500
X-IronPort-AV: E=Sophos;i="4.71,563,1320620400"; 
   d="scan'208";a="128723522"
Date: Tue, 24 Jan 2012 21:36:17 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
In-Reply-To: <20120124202203.GD1135@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1201242135430.1998@hadrien>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Mark Brown wrote:

> On Tue, Jan 24, 2012 at 06:29:13PM +0100, Julia Lawall wrote:
>
>>  	if (IS_ERR(saif->clk)) {
>> -		ret = PTR_ERR(saif->clk);
>>  		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
>>  			ret);
>> -		goto failed_clk;
>> +		return PTR_ERR(saif->clk);
>
> Looks like the transformation is overly enthusiastic here - the
> assignment to ret is removed but ret is used in the log message.

Uh, no, I did that stupid thing by hand.  I'll fix it.  Thanks.

julia
