Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2JROLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:11:08 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59606 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2JROLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121018135927.GD2739@arwen.pp.htv.fi>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121017130918.GD11394@arwen.pp.htv.fi>
	<1350481018.3568.3.camel@smile>
	<20121017135306.GG11394@arwen.pp.htv.fi>
	<1350548131.3568.6.camel@smile>
	<20121018103413.GB1449@arwen.pp.htv.fi>
	<1350558583.3568.9.camel@smile>
	<20121018135927.GD2739@arwen.pp.htv.fi>
Date: Thu, 18 Oct 2012 17:11:04 +0300
Message-ID: <CAHp75Vd2N8GsEL32vM3ciDNexqrFZcbSzYMX05LSf5L+-ZF7+Q@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding macros
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 4:59 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Oct 18, 2012 at 02:09:43PM +0300, Andy Shevchenko wrote:
>> On Thu, 2012-10-18 at 13:34 +0300, Felipe Balbi wrote:
>> > On Thu, Oct 18, 2012 at 11:15:31AM +0300, Andy Shevchenko wrote:
>> > > On Wed, 2012-10-17 at 16:53 +0300, Felipe Balbi wrote:
>> > > > On Wed, Oct 17, 2012 at 04:36:58PM +0300, Andy Shevchenko wrote:
>> > > > > On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote:
>>
>> > > > > > > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>>
>> > > > > > > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
>> > > > > > >    * controller flagged an error instead of scribbling over
>> > > > > > >    * random memory locations.
>> > > > > > >    */
>> > > > > > > - dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
>> > > > > > > -                 "Bad descriptor submitted for DMA!\n");
>> > > > > > > - dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
>> > > > > > > -                 "  cookie: %d\n", bad_desc->txd.cookie);
>> > > > > > > + dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
>> > > > > > > + dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);
>> > > > > >
>> > > > > > now this is critical, indeed. I would suggest using dev_WARN_ONCE() so
>> > > > > > that it's noisy enough to catch the failing user.
>> > > > > To this and upper comment, there is an explanation why it's critical. I
>> > > > > guess the WARN_ONCE is not good enough, for example if we have more than
>> > > > > one user making such noise.
>> > > >
>> > > > then use dev_WARN()
>> > > I can't see how dev_WARN could be more useful here than the dev_crit. In
>> > > current message we have channel and cookie to link back to the user.
>> > > What does WARN add meaningful?
>> >
>> > a dump_stack()
>>
>> How could it be useful? The dwc_handle_error is called from a tasklet
>> that is called from scheduler asynchronously. The tasklet is queued in
>> interrupt handler.
>
> even if it's not useful, it's a lot more verbose and more likely to get
> user's attention. If someone's passing broken DMA descriptor, it should
> be a really big fat warning so we can get user reports early enoough.

I will do separate patch for this. If Viresh and/or Vinoud is okay
with it, user will see fat message.

-- 
With Best Regards,
Andy Shevchenko
