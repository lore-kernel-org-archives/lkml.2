Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0ERSYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:24:42 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33716 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab0ERSYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:24:40 -0400
Date: Tue, 18 May 2010 20:24:23 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/3] power/ds2760_battery: make charge_now and
 charge_full writeable
Message-ID: <20100518182422.GJ30801@buzzloop.caiaq.de>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-2-git-send-email-daniel@caiaq.de>
 <20100511172003.GA19937@oksana.dev.rtsoft.ru>
 <20100511172859.GE30801@buzzloop.caiaq.de>
 <20100511180551.GA27795@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511180551.GA27795@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the late follow-up)

On Tue, May 11, 2010 at 10:05:51PM +0400, Anton Vorontsov wrote:
> On Tue, May 11, 2010 at 07:28:59PM +0200, Daniel Mack wrote:
> [...]
> > > 1. Could you at least change this back to
> > >    POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, so it'll be clear what
> > >    exactly this prop is actually changing, and
> > 
> > Do you see any other way to store the actual rated capacity (not the one
> > the battery had in its good days) inside the chip?
> 
> In that case it should be indeed POWER_SUPPLY_PROP_CHARGE_FULL,
> which is full_active_uAh, which we get from di->raw[DS2760_ACTIVE_FULL]
> and di->raw[DS2760_ACTIVE_FULL + 1].
> 
> We fall back to deriving it from rated_capacity if full_active
> is 0 (your case?):
> 
>         /* If the full_active_uAh value is not given, fall back to the rated
>          * capacity. This is likely to happen when chips are not part of the
>          * battery pack and is therefore not bootstrapped. */
>         if (di->full_active_uAh == 0)
>                 di->full_active_uAh = di->rated_capacity / 1000L;
> 
> So, you probably want to make DS2760_ACTIVE_FULL writable, not
> DS2760_RATED_CAPACITY.

Ah of course. And DS2760_ACTIVE_FULL is 16bit wide, so we also get rid
of the range problem.

Thanks,
Daniel
