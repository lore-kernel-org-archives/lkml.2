Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2IRH73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:59:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2IRH72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <1347951305.13371.10.camel@smile>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
	<1347951305.13371.10.camel@smile>
Date: Tue, 18 Sep 2012 13:29:28 +0530
X-Google-Sender-Auth: EsB9_94bCPqaqDbe4jy-2mDcXyg
Message-ID: <CAOh2x=k3hjXtuAd23LYLWvG59HPgFS8W2J+5-2Bre+wFufgcng@mail.gmail.com>
Subject: Re: [PATCH 2/7] dw_dmac: fill optional encoded parameters in register structure
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 12:25 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>> > +#define dma_raw_readl(addr, name) \
>> > +       readl((addr) + offsetof(struct dw_dma_regs, name))
>> > +
>> > +#define dma_raw_writel(addr, name, val) \
>> > +       writel((val), (addr) + offsetof(struct dw_dma_regs, name))
>> > +
>>
>> But why don't you use earlier defined readl/writel macros:
>> dma_readl and dma_writel?

> If you look at further patches, namely 3rd, the access to the register
> is needed before we allocate memory for the dw_dma structure.

Ok. If i am not wrong, such calls are only required once for below line:

dw_params = dma_raw_readl(regs, DW_PARAMS

dma_raw_writel() is not used and shouldn't be required in future too.
So remove it.
dma_raw_readl() is required but the name is a bit confusing... this
raw type is different
from raw_readl...

Can we name it dma_read_byaddr()?

to make it more explicit.

viresh
