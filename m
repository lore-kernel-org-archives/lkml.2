Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0IIBLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 21:11:49 -0400
Received: from helicon.mas.viperplatform.net.au ([202.147.75.21]:60993 "EHLO
	helicon.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab0IIBLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 21:11:43 -0400
X-Greylist: delayed 4130 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2010 21:11:43 EDT
Date: Thu, 9 Sep 2010 10:02:45 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100909000245.GK14056@atomos.longlandclan.yi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm currently writing a driver for an in-house developed sensor
controller device.  This device communicates via I²C, and functions as a
multi-function device incorporating:

- Touchscreen controller
- Keypad/Button controller
- LED driver
- Voltage/current monitor
- Temperature sensor monitor
- Light sensor monitor
- PIR (motion) detection monitor
- Communications interface (for slow serial links like Wiegand)

Our target is a Ka-Ro TX27 module, running their supplied kernel
(2.6.28)... however I'm not afraid to backport things from the latest
kernel, or to forward port any changes for mainline kernel inclusion.
(I've already got an experimental patchset that gets these things
booting kernel 2.6.34.)

The first three on this list, I've got settled pretty nicely using
existing interfaces.  The things I'm not sure about, are the remaining
interfaces, and how to best write a driver for them.

How are voltage *monitors* normally written?  (note, not voltage
*regulators*... this thing does not alter the voltage rails.)  I tried
to make sense of lm-sensors, but that seems very ad-hoc (maybe I missed
some document that explains it) to me.  It's hard to be clear on what is
the *right* way to report a voltage or current reading to userspace.

For the temperature and light sensing... temperature sensors certainly
exist in the PC world, and maybe I should look closely at how they are
normally done, but I wasn't sure about the light sensor.  I was thinking
maybe an input device with some new absolute value reported?

Likewise with the PIR sensor, I notice there's a "gesture" input
(MSC_GESTURE)... seems appropriate?  Or am I barking up the wrong tree?

The other feature is for things like Wiegand... Looking around I cannot
see any interface in the Linux kernel for Wiegand interfaces.

<http://en.wikipedia.org/wiki/Wiegand_protocol>

Given the likely use of embedded Linux in security systems, it makes
sense to come up with a suitable interface out in the open, rather than
everyone coming up with their own device-specific interfaces.

Apologies if this has been asked before, but I've looked around and
haven't seen anything... so I figured before I get too deep into this,
I'd enquire about the Right Way it should be done. ;-)

Regards,
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
