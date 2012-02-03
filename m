Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2BCIrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:47:53 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:52714 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2BCIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:47:51 -0500
X-IronPort-AV: E=Sophos;i="4.73,351,1325430000";   d="scan'208";a="66508673"
Message-id: <4F2B9F34.60308@renesas.com>
Date: Fri, 03 Feb 2012 17:47:48 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120129
 Thunderbird/10.0
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange> <4F27CA7D.601@renesas.com>
 <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi-san,

2012/02/03 7:19, Guennadi Liakhovetski wrote:
[ snip ]
>>
>> Thank you for your comment.
>>
>> I investigaed the issue. I found out the renesas_usbhs driver may
>> call tx_submit() in the callback() of the dma-simple finally.
> 
> Sorry, in my first reply to this your email I misread the renesas_usbhs 
> for an issue with your new SUDMAC driver. Since this is not the case and 
> my patch seems to be causing a regression, I'll look at it.

Thank you for the comment.

I found out that if the "power_up" is 0 in the sample_tx_submit(),
the pm_state will be changed to "PENDING".
And then, even if the renesas_usbhs calls dma_async_issue_pending(),
the dma-simple driver doesn't call the simple_chan_xfer_ld_queue().
This is because the driver will call the simple_chan_xfer_ld_queue()
when the pm_state is "ESTABLISHED" only.

So I guess that we have to modify the simple_issue_pending().

Best regards,
Yoshihiro Shimoda

> Thanks
> Guennadi
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
-- 
Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
