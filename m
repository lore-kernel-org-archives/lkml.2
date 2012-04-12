Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab2DLDoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:44:14 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:46234 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716Ab2DLDoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:44:13 -0400
Message-ID: <4F864F1E.8030708@st.com>
Date: Thu, 12 Apr 2012 09:12:22 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH 2/2 v2] dma/amba-pl08x: add support for the Nomadik variant
References: <1334185214-27250-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1334185214-27250-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 4:30 AM, Linus Walleij wrote:
> The Nomadik PL080 variant has some extra protection bits that
> may be set, so we need to check these bits to see if the
> channels are actually available for the DMAengine to use.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Alim Akhtar <alim.akhtar@gmail.com>
> Cc: Alessandro Rubini <rubini@gnudd.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> @@ -1917,7 +1926,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	}
>  
>  	/* Initialize physical channels */
> -	pl08x->phy_chans = kmalloc((vd->channels * sizeof(*pl08x->phy_chans)),
> +	pl08x->phy_chans = kzalloc((vd->channels * sizeof(*pl08x->phy_chans)),
>  			GFP_KERNEL);
>  	if (!pl08x->phy_chans) {
>  		dev_err(&adev->dev, "%s failed to allocate "
> @@ -1934,6 +1943,22 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  		spin_lock_init(&ch->lock);
>  		ch->serving = NULL;

I meant removing this one too. :)

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
