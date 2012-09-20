Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2ITJaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:30:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:15080 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab2ITJaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="195229001"
Message-ID: <1348133405.13371.30.camel@smile>
Subject: Re: [PATCH 2/7] dw_dmac: fill optional encoded parameters in
 register structure
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:30:05 +0300
In-Reply-To: <CAOh2x=k3hjXtuAd23LYLWvG59HPgFS8W2J+5-2Bre+wFufgcng@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
	 <1347951305.13371.10.camel@smile>
	 <CAOh2x=k3hjXtuAd23LYLWvG59HPgFS8W2J+5-2Bre+wFufgcng@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 13:29 +0530, viresh kumar wrote: 
> On Tue, Sep 18, 2012 at 12:25 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >> > +#define dma_raw_readl(addr, name) \
> >> > +       readl((addr) + offsetof(struct dw_dma_regs, name))
> >> > +
> >> > +#define dma_raw_writel(addr, name, val) \
> >> > +       writel((val), (addr) + offsetof(struct dw_dma_regs, name))
> >> > +
> >>
> >> But why don't you use earlier defined readl/writel macros:
> >> dma_readl and dma_writel?
> 
> > If you look at further patches, namely 3rd, the access to the register
> > is needed before we allocate memory for the dw_dma structure.
> 
> Ok. If i am not wrong, such calls are only required once for below line:
Actually twice... 
> dw_params = dma_raw_readl(regs, DW_PARAMS
...here and for channel parameters.

> dma_raw_writel() is not used and shouldn't be required in future too.
> So remove it.
Ok

> dma_raw_readl() is required but the name is a bit confusing... this
> raw type is different
> from raw_readl...
> 
> Can we name it dma_read_byaddr()?
> to make it more explicit.
Ok.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
