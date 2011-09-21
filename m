Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1IULLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 07:11:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:44178 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1IULLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 07:11:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,416,1312182000"; 
   d="scan'208";a="19163793"
Date: Wed, 21 Sep 2011 14:12:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 1/3] mfd: add Intel MSIC driver
Message-ID: <20110921111220.GL23578@intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
 <dfff721c25a64c9fe77d3b14772e0b3325f47ff9.1315399396.git.mika.westerberg@linux.intel.com>
 <20110920171742.GU32263@sortiz-mobl>
 <20110921080717.GK23578@intel.com>
 <20110921104456.GV32263@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921104456.GV32263@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:44:56PM +0200, Samuel Ortiz wrote:
> Hi Mika,
> 
> On Wed, Sep 21, 2011 at 11:07:17AM +0300, Mika Westerberg wrote:
> > > > +/*
> > > > + * Other MSIC related devices which are not directly available via SFI DEVS
> > > > + * table. 
> > > Would that mean a broken firmware, or something else I'm missing ?
> > > It looks odd.
> > 
> > Not all devices in the MSIC are listed in SFI DEVS table. For example
> > regulators are missing. We currently don't have regulator support for MSIC
> > but once it is added the devices will be created here.
> > 
> > Audio codec is similar - it does not exist in the SFI DEVS table.
> Ok. So I can expect further patches removing this one then.

For the regulators and audio codec, I'm not sure whether we ever get those
added to the SFI table. But we know that they will be embedded in the MSIC
chip.

It might be the case that we need to add there more stuff - regulators come
into mind when we get driver for them.

> 
> > > > +/**
> > > > + * intel_msic_reg_read - read a single MSIC register
> > > > + * @reg: register to read
> > > > + * @val: register value is placed here
> > > > + *
> > > > + * Read a single register from MSIC. Returns %0 on success and negative
> > > > + * errno in case of failure.
> > > > + *
> > > > + * Function may sleep.
> > > > + */
> > > > +int intel_msic_reg_read(unsigned short reg, u8 *val)
> > > > +{
> > > > +	return intel_scu_ipc_ioread8(reg, val);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(intel_msic_reg_read);
> > > > +
> > > > +/**
> > > > + * intel_msic_reg_write - write a single MSIC register
> > > > + * @reg: register to write
> > > > + * @val: value to write to that register
> > > > + *
> > > > + * Write a single MSIC register. Returns 0 on success and negative
> > > > + * errno in case of failure.
> > > > + *
> > > > + * Function may sleep.
> > > > + */
> > > > +int intel_msic_reg_write(unsigned short reg, u8 val)
> > > > +{
> > > > +	return intel_scu_ipc_iowrite8(reg, val);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(intel_msic_reg_write);
> > > What is the benefit of those wrappers since you're probably not going to get
> > > rid of the SCU IPC APIs, right ? What's wrong with the subdevices using the
> > > SCU IPC API directly ?
> > 
> > Right, we are not going to get rid of SCU IPC APIs. The idea behind having
> > these register access wrapper functions is that we are now able to separate
> > the MSIC subdevices from other SCU IPC usage. In other words we get a bit
> > cleaner "architecture".
> I'm not entirely convinced that wrapping around the IPC API gives you a
> cleaner architecture.

Ok.

> 
>  
> > It also allows us to add caching and intercepting register accesses if a
> > need rises.
> That would define a real need for this API, yes.

Ok.

> 
> 
> > > > +	for (i = 0; i < ARRAY_SIZE(msic_devs); i++) {
> > > > +		if (!pdata->irq[i])
> > > > +			continue;
> > > I would expect some sort of warning here since it would mean your platform
> > > code defined a sub device platform data without giving you the right IRQ. And
> > > afaiu, all of your sub devices must have one.
> > 
> > The interface for platform data says that if irq is zero, it means that no
> > platform device is created.
> > 
> > For example in patch 3/3 we add the platform data for battery, gpio, audio,
> > power_button and ocd but the SFI table actually contains more devices. We
> > don't yet have (upstream) driver for those so there is a little point of
> > creating platform device for them at this point.
> 
> Ok, I see.
> 
> So, I'm fine with this patch, at least the MFD part. I'll go ahead and apply
> it to my for-next branch. I'd appreciate to get ACKs or NACKs for the x86
> parts from the relevant people though.

Thanks.

I would also like to hear what x86 maintainers think about those parts.
Hmm, is there some mailing list which I missed or did forgot to Cc someone?
