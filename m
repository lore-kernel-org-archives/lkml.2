Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0C3IMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:12:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab0C3IMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:12:12 -0400
Date: Tue, 30 Mar 2010 10:12:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v4 1/6] hid: new driver for PicoLCD device
In-Reply-To: <20100329121611.0c22dcaf@pluto.restena.lu>
Message-ID: <alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home> <20100324234022.0361bd80@neptune.home> <20100326065656.GC26602@core.coreip.homeip.net> <20100326102951.3b9ecda1@neptune.home> <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz> <20100327012245.0ace6a09@neptune.home>
 <alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz> <20100329121611.0c22dcaf@pluto.restena.lu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Bruno Prémont wrote:

> > > +static struct hid_driver picolcd_driver = {
> > > +	.name =          "hid-picolcd",
> > > +	.id_table =      picolcd_devices,
> > > +	.probe =         picolcd_probe,
> > > +	.remove =        picolcd_remove,
> > > +	.raw_event =     picolcd_raw_event,
> > > +#ifdef CONFIG_PM
> > > +	.suspend =       picolcd_suspend,
> > > +	.resume =        picolcd_resume,
> > > +	.reset_resume =  picolcd_reset_resume,
> > > +#endif
> > > +};
> > 
> > struct hid_driver doesn't provide power-management related callbacks.
> > So I guess that you have either not tested this feature at all, or
> > you have some extra patch somewhere which adds such callbacks to HID
> > core, but you haven't sent it out for review?
> > 
> > In any cases, this will very likely cause compilation failure with 
> > CONFIG_PM turned on.
> 
> That's the patch I referred to (under series introduction mail) when
> saying:
> > The series depends on my previous patch adding HID suspend support
> > (I've not yet looked at improving it).
> 
> Link to the patch:
>   http://lkml.org/lkml/2010/2/24/233
> 
> Especially the reset-resume part is important as the device has to be
> reprogrammed with framebuffer content, brightness/contrast in that case.
> 
> As stated, Oliver didn't like the implementation of the addition of
> those hooks too much and I have yet to look at improving it.

Ah, OK, I have missed that one, thanks for pointing it out.

The driver itself now looks fine to me and I am willing to merge it, 
modulo the power-management code -- so please either remove the parts that 
depend on power management for now, or I'll wait on your respin of the 
generic HID-PM patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
