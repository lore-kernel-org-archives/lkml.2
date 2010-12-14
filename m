Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0LNLIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:08:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59852 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205Ab0LNLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:08:21 -0500
Date: Tue, 14 Dec 2010 11:08:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] intel_mid: Intel MSIC battery driver
Message-ID: <20101214110818.GA11489@rakim.wolfsonmicro.main>
References: <20101213153005.19966.16356.stgit@bob.linux.org.uk>
 <20101213162033.GA18736@sirena.org.uk>
 <12D0C12AF19E15409D57F22566E88EF505B045E598@bgsmsx501.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12D0C12AF19E15409D57F22566E88EF505B045E598@bgsmsx501.gar.corp.intel.com>
X-Cookie: Vitamin C deficiency is apauling.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:51:56PM +0530, Pallala, Ramakrishna wrote:

> > > +       if (mbi->ch_params.vinilmt == CHRG_CURR_SDP_LOW)
> > > +               mbi->usb_chrg_props.charger_type =
> > POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
> > > +       else
> > > +               mbi->usb_chrg_props.charger_type =
> > > +                                       POWER_SUPPLY_CHARGE_TYPE_FAST;

> > This isn't what fast and trickle charge are, they're not static
> > properties but rather reflect the kind of charging that's being done.

> If I understand correctly trickle charging will happen during full(or
> deeply discharge) charge conditions.  But as soon as I hit the charge
> full condition I am stopping the charging and will go into maintenance
> mode.  In maintenance mode I will check battery voltage to hit for
> lower threshold value and then enable the charging.  During
> maintenance mode battery voltage is near to FULL charge value, So can I
> set the charging type to trickle during maintenance  mode?

Given that it looks like this battery is capable of reporting more
detailed information such as the current that's being used to charge at
the moment I'm not sure it's worth supporting this property at all.  The
property exists because with the chargers used in many small embedded
devices use this something the hardware reports directly and you don't
get much more information than that.  If (as it seems) your charger has
no directly exported concept of different charge types then it's
probably safer to just not report this property and let userspace worry
about it.

The normal use for this information is figuring out why the battery is
taking longer than expected to charge - if the charger is stuck in
trickle charge then charging will take a very long time.
