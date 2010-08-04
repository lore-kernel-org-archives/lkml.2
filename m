Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0HDIog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:44:36 -0400
Received: from mail.perches.com ([173.55.12.10]:2251 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0HDIoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:44:34 -0400
Subject: Re: [PATCH 2.6.37? ] drivers/input: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100804080400.GA30735@core.coreip.homeip.net>
References: <1280860850.2963.24.camel@Joe-Laptop.home>
	 <20100804043256.GB25256@core.coreip.homeip.net>
	 <1280907222.1005.63.camel@Joe-Laptop.home>
	 <20100804080400.GA30735@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 01:44:32 -0700
Message-ID: <1280911472.1005.75.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 01:04 -0700, Dmitry Torokhov wrote:
> On Wed, Aug 04, 2010 at 12:33:42AM -0700, Joe Perches wrote:
> > On Tue, 2010-08-03 at 21:32 -0700, Dmitry Torokhov wrote:
> > > On Tue, Aug 03, 2010 at 11:40:50AM -0700, Joe Perches wrote:
> > > > Remove prefixes from printks and convert to pr_fmt/pr_<level>.
> > > Thanks for doing this, however instead of using pr_xxx() I'd like
> > > drivers that are integrated in driver model (serio, usb, gameport, etc,
> > > i.e. when we have 'struct device' available, exept for psmouse) to use
> > > drv_xxx() instead.
> > These files?
> > $ grep -rPl --include=*.[ch] "\bstruct\s+device\b" drivers/input | \
> >   xargs grep -wl pr_fmt
> > drivers/input/keyboard/omap-keypad.c
> > drivers/input/mousedev.c
> > drivers/input/serio/serio.c
> > drivers/input/serio/i8042.c
> > drivers/input/evdev.c
> > drivers/input/joydev.c
> > drivers/input/gameport/gameport.c
> > drivers/input/touchscreen/htcpen.c
> > drivers/input/input-polldev.c
> > drivers/input/input.c
> > drivers/input/tablet/aiptek.c
> > drivers/input/misc/winbond-cir.c
> > drivers/input/misc/yealink.c
> > drivers/input/misc/ati_remote2.c
> > drivers/input/misc/wistron_btns.c
> > drivers/input/misc/ati_remote.c
> > drivers/input/mouse/psmouse-base.c
> There should be more. USB for example. Basically anything but very old
> legacy drivers that never been converted to the 2.6 device model.

I propose you take the patch as-is and then conversions
from pr_<level>(...) to dev_<level>(struct device *, ...)
can be done as appropriate.

> > $ grep -l "define pr_fmt" drivers/input/mouse/*.[ch] | \
> >   xargs grep -il "ps2" 
> > drivers/input/mouse/alps.c
> > drivers/input/mouse/elantech.c
> > drivers/input/mouse/lifebook.c
> > drivers/input/mouse/logips2pp.c
> > drivers/input/mouse/psmouse-base.c
> psmouse-base should use KBUILD_MODNAME, for the rest of these
> KBUILD_BASENAME seems to fit.
> > drivers/input/mouse/sentelic.c
> > drivers/input/mouse/synaptics.c
> > drivers/input/mouse/trackpoint.c
> >
> > Which ones do you want converted? 
> > Any others?
> >No, I think this is it as far as PS/2 mice go.

OK, done.

Do you want a diff from the original,
a new single patch or patches by directory?

ie:

drivers/input/gameport
drivers/input/joystick
drivers/input/keyboard
drivers/input/misc
drivers/input/mouse
drivers/input/serio
drivers/input/tablet
drivers/input/touchscreen
drivers/input


