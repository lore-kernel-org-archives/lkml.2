Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2JOHfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:35:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:29276 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2JOHfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="205675725"
Message-ID: <1350286504.10584.176.camel@smile>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Date: Mon, 15 Oct 2012 10:35:04 +0300
In-Reply-To: <CAKohpo=20mwje+9AVgs7b-_DshyRO2DZ=Nacjm7vFAhed=Wkqg@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	 <9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	 <1350053897.10584.172.camel@smile>
	 <CAKohpo=20mwje+9AVgs7b-_DshyRO2DZ=Nacjm7vFAhed=Wkqg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 08:59 +0530, Viresh Kumar wrote: 
> On 12 October 2012 20:28, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >> +     if (last_dw) {
> >> +             if ((last_bus_id == param) && (last_dw == dw))
> >> +                     return false;
> >> +     }
> > Just came to my mind.
> > dw can't be NULL, can't it?
> > Then
> > if (last_dw) {
> > ...
> > }
> > is unneeded.
> 
> Fixup for this:
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d72c26f..764c159 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1196,11 +1196,8 @@ bool dw_dma_generic_filter(struct dma_chan
> *chan, void *param)
>          * failure. If dw and param are same, i.e. trying on same dw with
>          * different channel, return false.
>          */
> -       if (last_dw) {
> -               if ((last_bus_id == param) && (last_dw == dw))
> -                       return false;
> -       }
> -
> +       if ((last_dw == dw) && (last_bus_id == param))
> +               return false;
>         /*
>          * Return true:
>          * - If dw_dma's platform data is not filled with slave info, then all
Good.
So, have my 

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com> 

for this patch.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
