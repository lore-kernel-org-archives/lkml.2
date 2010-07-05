Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0GEPxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 11:53:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:1114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0GEPx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 11:53:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,540,1272870000"; 
   d="scan'208";a="815011527"
Date: Mon, 5 Jul 2010 17:53:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 22/26] MFD: Add JZ4740 ADC driver
Message-ID: <20100705155326.GC3850@sortiz-mobl>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
 <1276924111-11158-23-git-send-email-lars@metafoo.de>
 <20100705145306.GA3850@sortiz-mobl>
 <4C31FDA3.3040708@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C31FDA3.3040708@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 05:43:31PM +0200, Lars-Peter Clausen wrote:
> >> +static inline void jz4740_adc_clk_enable(struct jz4740_adc *adc)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&adc->lock, flags);
> >> +	if (adc->clk_ref++ == 0)
> >> +		clk_enable(adc->clk);
> >> +	spin_unlock_irqrestore(&adc->lock, flags);
> >> +}
> > I'm not familiar with your platform clock framework, but shouldn't the
> > refcounting be handled there instead of spread over all your drivers ?
> 
> The ADC clock is the only clock on this platform which is shared between multiple
> devices so I refrained from adding the refcounting to the core for now. But to be
> strictly complaint with the clock API as defined in linux/clk.h the implementation
> should do refcounting. I'm still a bit uncertain what would be done best here.
>
I can't see what leaving the refcount handling to drivers could bring compared
to a centralized implementation. But that's your platform, either way is fine
with me as far as this MFD driver is concerned.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
