Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2JOHcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:32:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:51335 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab2JOHcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="226928230"
Message-ID: <1350286310.10584.173.camel@smile>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness
 configurable
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Mon, 15 Oct 2012 10:31:50 +0300
In-Reply-To: <507B5B3E.60102@yahoo.es>
References: <507A6FA5.1000800@yahoo.es>
	 <CAHp75VdaqzoJPwJpQ9U1kpR-egveajeM71FLAxveWHz7gB+6Eg@mail.gmail.com>
	 <507B5B3E.60102@yahoo.es>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 08:39 +0800, Hein Tibosch wrote: 
> Hi Andy,
> On 10/15/2012 4:08 AM, Andy Shevchenko wrote:
> > On Sun, Oct 14, 2012 at 10:54 AM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> >> From: Hein Tibosch <hein_tibosch@yahoo.es>
> >>
> >> The dw_dmac was originally developed for avr32 to be used with the Synopsys
> >> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
> >> <snip>
> >>  #define dma_readl(dw, name) \
> >> -       readl(&(__dw_regs(dw)->name))
> >> +       dma_readl_native(&(__dw_regs(dw)->name))
> >>  #define dma_writel(dw, name, val) \
> >> -       writel((val), &(__dw_regs(dw)->name))
> >> +       dma_writel_native((val), &(__dw_regs(dw)->name))
> >>
> >>  #define channel_set_bit(dw, reg, mask) \
> >>         dma_writel(dw, reg, ((mask) << 8) | (mask))
> > Why did you not change this one?
> 
> Because "dma_writel" already calls "dma_writel_native"
Sure,
looks good for me.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
