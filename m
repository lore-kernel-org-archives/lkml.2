Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0I2Evx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:51:53 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58341 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab0I2Evw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:51:52 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        Marek Vasut <marek.vasut@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Date: Wed, 29 Sep 2010 06:49:34 +0200
Subject: RE: [PATCH 1/7] pwm: Add pwm core driver
Thread-Topic: [PATCH 1/7] pwm: Add pwm core driver
Thread-Index: ActfUMFOeVIb8N0jSaO4C/FafBgPbgAP7GfQ
Message-ID: <F45880696056844FA6A73F415B568C69532DC8B7E4@EXDCVYMBSTM006.EQ1STM.local>
References: <1285659648-21409-1-git-send-email-arun.murthy@stericsson.com>
 <1285659648-21409-2-git-send-email-arun.murthy@stericsson.com>
 <4CA1AD2B.8000905@metafoo.de>
 <F45880696056844FA6A73F415B568C69532DC2FB6B@EXDCVYMBSTM006.EQ1STM.local>
 <4CA1BC16.3020702@metafoo.de>
 <F45880696056844FA6A73F415B568C69532DC2FC60@EXDCVYMBSTM006.EQ1STM.local>
 <4CA25841.4090702@metafoo.de>
In-Reply-To: <4CA25841.4090702@metafoo.de>
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

> Arun MURTHY wrote:
> >>>> Shouldn't PWM_DEVICES select HAVE_PWM?
> >>>
> >>> No not required, the entire concept is to remove HAVE_PWM and use
> >> PWM_CORE.
> >>
> >> Well in patch 4 you say that PWM_CORE is currently limited to ARM.
> >> Furthermore you
> >> change the pwm-backlight and pwm-led Kconfig entries to depend on
> >> HAVE_PWM ||
> >> PWM_CORE. Adding a select HAVE_PWM here would make those changes
> >> unnecessary.
> > HAVE_PWM is retained just because the mips pwm driver is not aligned
> with the pwm core driver.
> > On mips pwm driver aligning to the pwm core driver HAVE_PWM will be
> replaced by PWM_CORE.
> >
> >> HAVE_PWM should be set, when pwm_* functions are available. When
> your
> >> pwm-core driver
> >> is selected they are available.
> > On applying this patch set pwm_* function will be exported in
> pwm_core driver and in mips pwm driver.
> > Since mips pwm driver is not aligned with the pwm core, HAVE_PWM is
> retained and removed in places where pwm drivers register to pwm core
> driver.
> 
> pwm_{enable,disable,request,free} are the interface of the pwm api.
> Your pwm-core is
> one implementation of that interface. A somewhat special though,
> because it tries to
> be a generic implementation.
> There are still other implementations though. For example right now the
> mips jz4740 one.
> In my opinion HAVE_PWM should be defined if there is a implementation
> for the pwm
> interface is available.
> I know that your plan is that in the end pwm-core is the only
> implementation of the
> pwm interface.
Yes for that reason, I still have retained the HAVE_PWM, once that is
also aligned with pwm core, HAVE_PWM will be totally removed.
I am in the process of doing the same in this series of patch, but was
blocked by mips jz4740 pwm driver.
Will do that very soon in near future.

> 
> But right now it is not and on the other hand some SoC implementors
> might choose that
> they want to provide their own minimal pwm interface implementation.
> Furthermore this would allow you to start with pwm-core for one SoC
> which you have on
> your desk and where you can properly test things and keep the patches
> clean from
> clutter changing all the different archs.
> Once pwm-core is in a proper shape you or other people can start
> porting all the
> different SoC support code to pwm-core.
That's the exact reason for me to come up with this core driver, which has
the minimal part and the one that are common in all pwm drivers.
Not only common most if not all pwm drivers just make use of only these
functions.
Moreover I have aligned all existing pwm driver in my patch 4/7 :-)

> 
> Similar behavior is for example true for the gpio api. There is gpiolib
> which is the
> generic implementation which allows having gpio chips outside of the
> chip. On the
> other hand there are still archs which choose to have their own gpio
> api implementation.
> 
> >
> >>> pwm_device will be passed to each and every pwm driver that are
> >> registered as client with pwm core.
> >>> The list consists of the registered pwm drivers and is to be
> handled
> >> by pwm core.
> >>> Why should each and every pwm driver get to know about the entire
> pwm
> >> driver list?
> >> Declare the list field to be private, by saying that it should only
> be
> >> touched by the
> >> core. Right now you allocate a rather small additional structure for
> >> each registered
> >> device. This could be easily be avoided by embedding the list field
> >> into the
> >> pwm_device struct.
> >
> > The one that is being allocated in register is the pwm_device and
> this has to. Because each pwm driver will have their own data related
> to ops, pwm_id.
> > Also note that there exists an element "data" that points to the pwm
> device specific information. Hence this allocation is required.
> >
> >>>>> +	}
> >>>>> +	pwm->pwm_dev = pwm_dev;
> >>>>> +	list_add_tail(&pwm->list, &di->list);
> >>>>> +	up_write(&pwm_list_lock);
> >>>>> +
> >>>> I guess you only need to lock the list when accessing the list and
> >>>> adding the new
> >>>> pwm_dev.
> >>> Oops, thanks for pointing out, will implement this in the v2 patch.
> > Coming back to this, I guess the locking has to be done while
> traversing the list also, as my present pointer in the list my get over
> written by the time I add an element to list. Please let me know if I
> am wrong.
> >
> >>>>> +struct pwm_ops {
> >>>>> +	int (*pwm_config)(struct pwm_device *pwm, int duty_ns, int
> >>>> period_ns);
> >>>>> +	int (*pwm_enable)(struct pwm_device *pwm);
> >>>>> +	int (*pwm_disable)(struct pwm_device *pwm);
> >>>>> +	char *name;
> >>>>> +};
> >>>>> +
> >>>> Shouldn't name be part of the pwm_device? That would allow the ops
> >> to
> >>>> be shared
> >>>> between different devices.
> >>> Good catch, the reason being that 2 or more devices can share the
> >> same ops and get registered to pwm core.
> >>> But the catch lies while identifying the pwm device while the
> clients
> >> are requesting for.
> >>> The pwm backlight will request the pwm driver by name. This is
> >> parameter that distinguishes among different pwm devices
> irrespective
> >> of same ops or not.
> >> Yes. And thats why it should go into the pwm_device struct itself.
> >>
> >> If an additional ops struct is allocated for each device anyway we
> >> would be better of
> >> embedding it directly into the device struct instead of just holding
> a
> >> pointer to it.
> > Yes ops structure will be allocated. But how can we get access to the
> ops structure of another driver?
> > And moreover two pwm driver sharing same ops ideally means a single
> pwm module. If not everything atleast the pwm registers of two
> different modules changes. So this scenario can never occur.
> >
> >>>>>  #endif /* __LINUX_PWM_H */
> >>>> It might be also a good idea to add a device class for pwm
> devices.
> >>> Sure, but can you please explain with an example the use case.
> >>>
> >> Well, for one it helps to keep data structured.
> >> And there would be functions to traverse all devices of a class, so
> you
> >> could get rid
> >> of your "di" list.
> > Sorry, I didn't get you can you please elaborate more?
> >
> Sure. You would create a "struct class" device class for pwm devices.
> For each
> registered pwm device there would then be a "struct device"
> representing the pwm
> device whithin the linux device tree.
> This has serveral advantages:
> For one you can use this for keeping track of the all the pwm devices
> instead of
> having your custom list. You can use class_for_each_device and
> class_find_device
> instead of traversing your list. This would make the core much simpler
> and more readable.
> Also you can use the device structure for refcounting of modules and
> devices. Right
> now if a pwm-core driver, like the twl6040, is build as a module you
> can remove the
> module while another driver, for example pwm-backlight, is using a pwm
> device from
> the pwm-core driver. Then upon accessing the pwm device from the pwm-
> backlight driver
> the code would crash, because it would access already freed memory.
> 
Can this be taken after this patch is merged?

Thanks and Regards,
Arun R Murthy
------------

