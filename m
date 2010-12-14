Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0LNIWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:22:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:34137 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab0LNIWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:22:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,341,1288594800"; 
   d="scan'208";a="867939852"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 Dec 2010 13:51:56 +0530
Subject: RE: [RFC] intel_mid: Intel MSIC battery driver
Thread-Topic: [RFC] intel_mid: Intel MSIC battery driver
Thread-Index: Acua4bFStBW1+YGlToCQrPLSJfdS0AAe1EhQ
Message-ID: <12D0C12AF19E15409D57F22566E88EF505B045E598@bgsmsx501.gar.corp.intel.com>
References: <20101213153005.19966.16356.stgit@bob.linux.org.uk>
 <20101213162033.GA18736@sirena.org.uk>
In-Reply-To: <20101213162033.GA18736@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the comments.

> > +static enum power_supply_property msic_usb_props[] = {
> > +	POWER_SUPPLY_PROP_TYPE,
> > +	POWER_SUPPLY_PROP_CHARGE_TYPE,
> > +	POWER_SUPPLY_PROP_PRESENT,
> > +	POWER_SUPPLY_PROP_HEALTH,
> > +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> > +	POWER_SUPPLY_PROP_MODEL_NAME,
> > +	POWER_SUPPLY_PROP_MANUFACTURER,
> 
> It seems a bit odd that the USB interface has a charge related property
> - while it may be the current supply for the charger the thing that's
> actually being charged is the battery which doesn't have a charge type.
> See also below...
Agreed will fix it.

> 
> > +static int mdf_read_adc_regs(int sensor,
> > +			struct msic_power_module_info *mbi)
> 
> Might it be useful to push these into the core code for whatever you're
> talking to so that you can expose both power supply and hwmon interface
> versions of the supply monitoring?
Generic ADC driver development is in progress. I will remove this code as soon as the ADC driver comes in.
 

> > +static void msic_handle_exception(struct msic_power_module_info *mbi,
> > +		uint8_t CHRINT_reg_value, uint8_t CHRINT1_reg_value)
> > +{
> > +	enum msic_event exception;
> 
> I'd expect this to generate a power_supply_changed() too - it's possible
> I'm just missing the code for that somewhere else, though.
> 
Agreed will fix it.

> > +       if (mbi->ch_params.vinilmt == CHRG_CURR_SDP_LOW)
> > +               mbi->usb_chrg_props.charger_type =
> POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
> > +       else
> > +               mbi->usb_chrg_props.charger_type =
> > +                                       POWER_SUPPLY_CHARGE_TYPE_FAST;
> 
> This isn't what fast and trickle charge are, they're not static
> properties but rather reflect the kind of charging that's being done.
> Broadly speaking trickle charge means that charge is being fed slowly
> into the battery (usually at either extreme of the charge curve when the
> battery is either near full or near discharge) while fast charge means
> that charge is being pushed into the battery much more rapidly.  This
> will vary throughout the charge cycle.
> 
> It's likely that if the supply is constrained (eg, 100mA USB) then there
> won't be enough current to ever do a fast charge but the availability of
> more supply doesn't mean that we're in fast charge.

If I understand correctly trickle charging will happen during full(or deeply discharge) charge conditions.
But as soon as I hit the charge full condition I am stopping the charging and will go into maintenance mode.
In maintenance mode I will check battery voltage to hit for lower threshold value and then enable the charging.
During maintenance mode battery voltage is near to FULL charge value, So can I set the charging type to trickle during maintenance  mode?


