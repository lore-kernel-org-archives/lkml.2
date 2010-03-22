Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0CVE1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:27:50 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:54112 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0CVE1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kdIuXQ1pzTJJZ8lhNoHH1SwWh4IFnvd4ebZl9t62G42IluWTayHuaMIh6EY4uDdwvp
         Lc5P4mwCXhqZcfemud7sAfHxpiM7OLfkWT2xAWrW38HDXhoJ35yNlV06wd1wXgu3EdSK
         6VNIPA1n0VisP7BHTmdhR8z6mcDhGyIWBhIh4=
Date: Sun, 21 Mar 2010 21:27:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100322042742.GB31621@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <20100303190753.GB11471@core.coreip.homeip.net>
 <alpine.LSU.2.01.1003220110500.356@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1003220110500.356@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 01:13:29AM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2010-03-03 20:07, Dmitry Torokhov wrote:
> >On Wed, Mar 03, 2010 at 10:52:43AM -0800, Linus Torvalds wrote:
> >> On Wed, 3 Mar 2010, Dmitry Torokhov wrote:
> >>> 
> >>> Because in general ambient light sensor may have nothing to do
> >>> with the screen brightness. The fact that all current uses are
> >>> tied to controlling screen brightness is coincidential. You could
> >>> use it as well to turn on the lights in the kitchen if it is
> >>> getting too dark...
> >> 
> >> But my point is, it acts pretty much like a key on a keyboard 
> >> _regardless_. 
> >> 
> >> Sure, you migth use it to turn up the lights too. But how is that 
> >> different from having a switch to do the same? Again, it doesn't sound 
> >> that different from a key to me.
> >
> >I guess for me the distinction is that the event was not caused by an
> >action of a human being but by change in environment.
> 
> Power failure is also usually not caused by an action of a human, and
> yet, (some brands/models of) uninterruptible power supplies present
> these events through USBHID/input.

USBHID - yes, input - no. Let's not confuse transport with subsystem.

As we witnessed in another thread some vendors used HID for industrial
sensors (temperature IIRC) and write applications using joystick
interface (/dev/input/jsX). It does not mean this is the best approach.

Same goes for laptop vendors using 'free' scancodes to deliver
additional events via i8042. The fact that they "extend" KBC data
stream still does not make them input events.

-- 
Dmitry
