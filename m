Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0HDIEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:04:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0HDIEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EopGkJ+es+QiHiDJQMkiAukPMmN9v1NTJrDdy99k2R7wpdnySLGVpUYSX7FV7RSaVq
         093IDYZFlv066At4y30sThPEPp3MeyjtI/OBpaK3b1DysXIc9YB7FqDoaZzyu7GszY7N
         4gsPtm1Zq+XMFB46DkJpU8tmOYgBi93c0rEy4=
Date: Wed, 4 Aug 2010 01:04:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.37? ] drivers/input: Use pr_<level>
Message-ID: <20100804080400.GA30735@core.coreip.homeip.net>
References: <1280860850.2963.24.camel@Joe-Laptop.home>
 <20100804043256.GB25256@core.coreip.homeip.net>
 <1280907222.1005.63.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280907222.1005.63.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:33:42AM -0700, Joe Perches wrote:
> On Tue, 2010-08-03 at 21:32 -0700, Dmitry Torokhov wrote:
> > Hi Joe,
> 
> Hi Dmitry.
> 
> > On Tue, Aug 03, 2010 at 11:40:50AM -0700, Joe Perches wrote:
> > > Remove prefixes from printks and convert to pr_fmt/pr_<level>.
> > Thanks for doing this, however instead of using pr_xxx() I'd like
> > drivers that are integrated in driver model (serio, usb, gameport, etc,
> > i.e. when we have 'struct device' available, exept for psmouse) to use
> > drv_xxx() instead.
> 
> These files?
> $ grep -rPl --include=*.[ch] "\bstruct\s+device\b" drivers/input | \
>   xargs grep -wl pr_fmt
> drivers/input/keyboard/omap-keypad.c
> drivers/input/mousedev.c
> drivers/input/serio/serio.c
> drivers/input/serio/i8042.c
> drivers/input/evdev.c
> drivers/input/joydev.c
> drivers/input/gameport/gameport.c
> drivers/input/touchscreen/htcpen.c
> drivers/input/input-polldev.c
> drivers/input/input.c
> drivers/input/tablet/aiptek.c
> drivers/input/misc/winbond-cir.c
> drivers/input/misc/yealink.c
> drivers/input/misc/ati_remote2.c
> drivers/input/misc/wistron_btns.c
> drivers/input/misc/ati_remote.c
> drivers/input/mouse/psmouse-base.c

There should be more. USB for example. Basically anything but very old
legacy drivers that never been converted to the 2.6 device model.

>   
> > That would make synaptics messages to come as "psmouse", right?
> 
> Yes.
> 
> > I think we should use
> > 	#define pr_fmt(fmt) "synaptics: " fmt
> > here and in the rest of specialized PS/2 protocol handlers.
> 
> Perhaps convert to what elantech uses
> #define pr_fmt(fmt) KBUILD_BASENAME ": " fmt
> 
> $ grep -l "define pr_fmt" drivers/input/mouse/*.[ch] | \
>   xargs grep -il "ps2" 
> drivers/input/mouse/alps.c
> drivers/input/mouse/elantech.c
> drivers/input/mouse/lifebook.c
> drivers/input/mouse/logips2pp.c
> drivers/input/mouse/psmouse-base.c

psmouse-base should use KBUILD_MODNAME, for the rest of these
KBUILD_BASENAME seems to fit.

> drivers/input/mouse/sentelic.c
> drivers/input/mouse/synaptics.c
> drivers/input/mouse/trackpoint.c
> 
> Which ones do you want converted? 
> Any others?
> 

No, I think this is it as far as PS/2 mice go.

-- 
Dmitry
