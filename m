Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1LOHVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:21:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab1LOHVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:21:35 -0500
Date: Wed, 14 Dec 2011 23:18:59 -0800
From: Greg KH <gregkh@suse.de>
To: myungjoo.ham@gmail.com
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 1/3] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20111215071859.GA13584@suse.de>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
 <1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
 <20111215010108.GA15650@suse.de>
 <CAJ0PZbRRiMoEDEV5vwr9rREfSejA_hqLMDmLMBoUBZKjafYq1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ0PZbRRiMoEDEV5vwr9rREfSejA_hqLMDmLMBoUBZKjafYq1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 02:41:38PM +0900, MyungJoo Ham wrote:
> On Thu, Dec 15, 2011 at 10:01 AM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Dec 14, 2011 at 07:28:26PM +0900, MyungJoo Ham wrote:
> >> External connector class (extcon) is based on and an extension of Android
> >> kernel's switch class located at linux/drivers/switch/.
> >> This patch provides the before-extension switch class moved to the
> >> location where the extcon will be located (linux/drivers/extcon/).
> >>
> >> The before-extension class, switch class of Android kernel, commits
> >> imported are:
> >>
> >> switch: switch class and GPIO drivers.
> >> Author: Mike Lockwood <lockwood@android.com>
> >>
> >> switch: gpio: Don't call request_irq with interrupts disabled
> >> Author: Arve Hjønnevåg <arve@android.com>
> >>
> >> switch: Use device_create instead of device_create_drvdata.
> >> Author: Arve Hjønnevåg <arve@android.com>
> >>
> >> switch_gpio: Add missing #include <linux/interrupt.h>
> >> Author: Mike Lockwood <lockwood@android.com>
> >>
> >> In this patch, upon the commits of Android kernel, we have added:
> >> - Relocated and renamed for extcon.
> >> - Comments, module name, and author information are updated
> >> - Code clean for successing patches
> >> - Bugfix: enabling write access without write functions
> >
> > Nice, but if we accept this, will someone also make the needed changes
> > to the Android userspace code to handle the user api changes that this
> > causes?
> 
> I have no idea about how Android will react to this as I have no
> developmental experiences with Android.
> However, from the perspective of general userspace, this modification
> incurs path changes (/sys/class/switch/.... to /sys/class/extcon/...)
> only.

Well, without such changes, any Android platform will still have to
include the switch code in their system, making this work a bit
pointless, right?

Please look into changing this in userspace, if for no other reason than
to test that this kernel code works properly with the Android userspace
needs as well.

> >> +                     kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
> >
> > I really dislike using uevents, what is listening for them?  Are you
> > hooked into udev's event chain in userspace to properly handle this?  If
> > not, what is the point of sending them?
> 
> It is to let userspace processes get notified for the events in extcon.
> Do you think sysfs_notify() would be better for this purpose?

No, I don't think it does what you think it does :)

What are you trying to accomplish here?  And how would sysfs_notify()
accomplish that?

thanks,

greg k-h
