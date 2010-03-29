Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0C2KQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:16:16 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:48385 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0C2KQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:16:14 -0400
Date: Mon, 29 Mar 2010 12:16:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v4 1/6] hid: new driver for PicoLCD device
Message-ID: <20100329121611.0c22dcaf@pluto.restena.lu>
In-Reply-To: <alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home>
	<20100324234022.0361bd80@neptune.home>
	<20100326065656.GC26602@core.coreip.homeip.net>
	<20100326102951.3b9ecda1@neptune.home>
	<alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
	<20100327012245.0ace6a09@neptune.home>
	<alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 11:47:27 +0200 Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 27 Mar 2010, Bruno Prémont wrote:
> 
> > +#ifdef CONFIG_PM
> > +static int picolcd_suspend(struct hid_device *hdev)
> > +{
> > +	dbg_hid(PICOLCD_NAME " device ready for suspend\n");
> > +	return 0;
> > +}
> > +
> > +static int picolcd_resume(struct hid_device *hdev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int picolcd_reset_resume(struct hid_device *hdev)
> > +{
> > +	int ret;
> > +	ret = picolcd_reset(hdev);
> > +	if (ret)
> > +		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
> > +	return 0;
> > +}
> > +#endif
> [ ... ]
> > +static struct hid_driver picolcd_driver = {
> > +	.name =          "hid-picolcd",
> > +	.id_table =      picolcd_devices,
> > +	.probe =         picolcd_probe,
> > +	.remove =        picolcd_remove,
> > +	.raw_event =     picolcd_raw_event,
> > +#ifdef CONFIG_PM
> > +	.suspend =       picolcd_suspend,
> > +	.resume =        picolcd_resume,
> > +	.reset_resume =  picolcd_reset_resume,
> > +#endif
> > +};
> 
> struct hid_driver doesn't provide power-management related callbacks.
> So I guess that you have either not tested this feature at all, or
> you have some extra patch somewhere which adds such callbacks to HID
> core, but you haven't sent it out for review?
> 
> In any cases, this will very likely cause compilation failure with 
> CONFIG_PM turned on.

That's the patch I referred to (under series introduction mail) when
saying:
> The series depends on my previous patch adding HID suspend support
> (I've not yet looked at improving it).

Link to the patch:
  http://lkml.org/lkml/2010/2/24/233

Especially the reset-resume part is important as the device has to be
reprogrammed with framebuffer content, brightness/contrast in that case.


As stated, Oliver didn't like the implementation of the addition of
those hooks too much and I have yet to look at improving it.

Thanks,
Bruno
