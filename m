Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab0HEGor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:44:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53181 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759711Ab0HEGoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=KKpi/p1N0RfwnOGsnBWRW1qIqAZjizE/aJwscp3layAbHb/GlzA+doF9q9mk0QI9TB
         0Xd186UkAZzGAWxLTSgTPM8JwlnSEv/tLans5NGUAbJ9MDANmf8YkMgnK5xI3Kmzy0pz
         U7v3dNqrUhdlYSaPtFIjfvFaOcCDtfaHcP0Ik=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2.6.37? ] drivers/input: Use pr_<level>
Date: Wed, 4 Aug 2010 23:44:39 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.4.5; x86_64; ; )
Cc: "linux-input" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1280860850.2963.24.camel@Joe-Laptop.home> <20100804080400.GA30735@core.coreip.homeip.net> <1280911472.1005.75.camel@Joe-Laptop.home>
In-Reply-To: <1280911472.1005.75.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042344.39930.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 04, 2010 01:44:32 am Joe Perches wrote:
> On Wed, 2010-08-04 at 01:04 -0700, Dmitry Torokhov wrote:
> > On Wed, Aug 04, 2010 at 12:33:42AM -0700, Joe Perches wrote:
> > > On Tue, 2010-08-03 at 21:32 -0700, Dmitry Torokhov wrote:
> > > 
> > > These files?
> > > $ grep -rPl --include=*.[ch] "\bstruct\s+device\b" drivers/input | \
> > >
> > >   xargs grep -wl pr_fmt
> > >
> > > drivers/input/keyboard/omap-keypad.c
> > > drivers/input/mousedev.c
> > > drivers/input/serio/serio.c
> > > drivers/input/serio/i8042.c
> > > drivers/input/evdev.c
> > > drivers/input/joydev.c
> > > drivers/input/gameport/gameport.c
> > > drivers/input/touchscreen/htcpen.c
> > > drivers/input/input-polldev.c
> > > drivers/input/input.c
> > > drivers/input/tablet/aiptek.c
> > > drivers/input/misc/winbond-cir.c
> > > drivers/input/misc/yealink.c
> > > drivers/input/misc/ati_remote2.c
> > > drivers/input/misc/wistron_btns.c
> > > drivers/input/misc/ati_remote.c
> > > drivers/input/mouse/psmouse-base.c
> > 
> > There should be more. USB for example. Basically anything but very old
> > legacy drivers that never been converted to the 2.6 device model.
> 
> I propose you take the patch as-is and then conversions
> from pr_<level>(...) to dev_<level>(struct device *, ...)
> can be done as appropriate.
> 
> > > $ grep -l "define pr_fmt" drivers/input/mouse/*.[ch] | \
> > >
> > >   xargs grep -il "ps2" 
> > >
> > > drivers/input/mouse/alps.c
> > > drivers/input/mouse/elantech.c
> > > drivers/input/mouse/lifebook.c
> > > drivers/input/mouse/logips2pp.c
> > > drivers/input/mouse/psmouse-base.c
> > 
> > psmouse-base should use KBUILD_MODNAME, for the rest of these
> > KBUILD_BASENAME seems to fit.
> > 
> > > drivers/input/mouse/sentelic.c
> > > drivers/input/mouse/synaptics.c
> > > drivers/input/mouse/trackpoint.c
> > > 
> > > Which ones do you want converted? 
> > > Any others?
> > >
> > >No, I think this is it as far as PS/2 mice go.
> 
> OK, done.
> 
> Do you want a diff from the original,
> a new single patch or patches by directory?

Split by directories, if possible, please.

-- 
Dmitry
