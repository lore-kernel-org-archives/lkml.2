Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0EKR3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:29:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34646 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0EKR3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:29:18 -0400
Date: Tue, 11 May 2010 19:28:59 +0200
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
Message-ID: <20100511172859.GE30801@buzzloop.caiaq.de>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-2-git-send-email-daniel@caiaq.de>
 <20100511172003.GA19937@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511172003.GA19937@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:20:03PM +0400, Anton Vorontsov wrote:
> 
> On Tue, May 11, 2010 at 06:38:45PM +0200, Daniel Mack wrote:
> [...]
> > +static int ds2760_battery_set_property(struct power_supply *psy,
> > +				       enum power_supply_property psp,
> > +				       const union power_supply_propval *val)
> > +{
> > +	int ret = -EPERM;
> > +	unsigned char tmp;
> > +	struct ds2760_device_info *di = to_ds2760_device_info(psy);
> > +
> > +	switch (psp) {
> > +	case POWER_SUPPLY_PROP_CHARGE_FULL:
> > +		/* the interface counts in uAh, convert the value */
> > +		ds2760_battery_write_rated_capacity(di, (val->intval / 1000L) /
> > +							RATED_CAPACITY_FACTOR);
> 
> OK, Mark hinted that you should not change rated (design)
> capacity, ever. You've made CHARGE_FULL writable, which now
> actually changes CHARGE_FULL_DESIGN (which reports
> rated_capacity). Obviously, this isn't acceptable.

Of course, sorry.

> I understand that you might want to change rated capacity for
> your custom battery setups, and that's fine. After all, it's
> your hardware, and you have a right to break it. :-)

Well, if it was a hack purely for my hardware, I wouldn't share it beat
it upstream ;) I believe that this feature is something all users of
battery-driven devices need, as all batteries age.

> But to do so,
> 
> 1. Could you at least change this back to
>    POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, so it'll be clear what
>    exactly this prop is actually changing, and

Do you see any other way to store the actual rated capacity (not the one
the battery had in its good days) inside the chip?

> 2. Can we introduce Kconfig symbol BATTERY_DS2760_UNSAFE_OPS,
>    and put an #ifdefs for this property? It should be
>    'default n', of course. Plus we can #ifdef the rated_capacity
>    module param as well.

Hmm, I see that this is one way. I can do this, but I'm hessitant and
would rather go a cleaer way ...


Thanks,
Daniel
