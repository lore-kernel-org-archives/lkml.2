Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab2H3MJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:09:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2H3MJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:09:17 -0400
Date: Thu, 30 Aug 2012 05:06:51 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] lp8727_charger: use IRQF_ONESHOT
Message-ID: <20120830120651.GA10779@lizard>
References: <20120823114229.GA16789@localhost>
 <A874F61F95741C4A9BA573A70FE3998F41EF1CF9@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF1CF9@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:41:54AM +0000, Kim, Milo wrote:
> > > ERROR: Threaded IRQ with no primary handler requested without
> > > IRQF_ONESHOT
> > >
> > > Make sure threaded IRQs without a primary handler are always request
> > > with IRQF_ONESHOT
> > >
> > > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> > > ---
> > >
> > > Note: I don't really know much about the situation, feel free to
> > > ignore it if it's an false warning.
> > >
> > >  cocci-output-25411-2ae2e0-lp8727_charger.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- a/drivers/power/lp8727_charger.c
> > > +++ b/drivers/power/lp8727_charger.c
> > > @@ -255,7 +255,7 @@ static int lp8727_intr_config(struct lp8
> > >  	return request_threaded_irq(pchg->client->irq,
> > >  				NULL,
> > >  				lp8727_isr_func,
> > > -				IRQF_TRIGGER_FALLING,
> > > +				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > >  				"lp8727_irq",
> > >  				pchg);
> > >  }
> > Thanks for the update.
> > 
> > Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> > 
> 
> Please refer to the patch below.
> [PATCH 4/8] lp8727_charger: cleanup the interrupt handler code
> This includes previous Fengguang' patch.

Nope, I'll include Fengguang's patch (he posted it first), and then
will try to apply the rest of your cleanups on top of it. If it helps,
your can incorporate the fix in your series, preserving the authorship.

Thanks.
