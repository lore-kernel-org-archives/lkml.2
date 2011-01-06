Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1AFU04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:26:56 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60134 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752344Ab1AFU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:26:54 -0500
Date: Thu, 6 Jan 2011 21:27:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc8
Message-ID: <20110106202712.GA1967@elf.ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
 <20110104142604.GA6591@ucw.cz>
 <849307$b0n4jp@azsmga001.ch.intel.com>
 <20110104210408.GA2008@elf.ucw.cz>
 <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
 <20110105220533.GA2700@elf.ucw.cz>
 <AANLkTikq9QHDk2zN+b8LFjrfqmHgtHWS8nT42hfiSwrz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikq9QHDk2zN+b8LFjrfqmHgtHWS8nT42hfiSwrz@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > And yes, I did git pull few minutes ago...
> >>
> >> Disable CONFIG_FB_VESA or remove the vga= line from the commandline for a
> >> first test.
> >
> > Yes, that helped, thanks. (But are not framebuffers expected to "take
> > over" and replace one another?)
> 
> In an ideal world they should, but vesafb can do things to the
> hardware and leave it in a bad
> state for the intel driver and it doesn't figure it out. Also I think
> the handover needs to be done
> earlier for Intel as well, like nouveau and radeon do.

Ok, I guess someone should write Doc*/fb/inteldrmfb.txt...

I got unaccelerated X working, good.

Section "Device"
        Identifier      "Generic Video Card"
#       Driver          "intel"
        Driver          "fbdev"
        Option          "UseFBDev"              "true"
EndSection

...but when I returned to machine, display did wake up but backlight
did not :-(.

But I still can't get accelerated X to work. I tried updating xserver:

Setting up xserver-xorg-video-intel (2:2.13.0-2) ...

Section "Device"
        Identifier      "Generic Video Card"
	Driver          "intel"
#        Driver          "fbdev"
        Option          "UseFBDev"              "true"
EndSection

but when I try to start X, I get:

xorg-server 2:1.7.7-8 (Cyril Brulebois <kibi@debian.org>)
Current version of pixman: 0.16.4
        Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Thu Jan  6 21:25:59 2011
(==) Using config file: "/etc/X11/xorg.conf"
(==) Using system config directory "/usr/share/X11/xorg.conf.d"
WARNING: All config files need .conf: /etc/modprobe.d/isapnp, it will
be ignored in a future release.
WARNING: All config files need .conf: /etc/modprobe.d/irda-utils, it
will be ignored in a future release.
WARNING: All config files need .conf: /etc/modprobe.d/arch, it will be
ignored in a future release.
WARNING: All config files need .conf: /etc/modprobe.d/thinkpad, it
will be ignored in a future release.
WARNING: All config files need .conf: /etc/modprobe.d/crypto, it will
be ignored in a future release.
FATAL: Could not load /lib/modules/2.6.37-rc8+/modules.dep: No such
file or directory
(EE) intel(0): [drm] Failed to open DRM device for pci:0000:00:02.0:
No such file or directory
(EE) intel(0): Failed to become DRM master.
DRM_IOCTL_I915_GEM_APERTURE failed: Bad file descriptor
Assuming 131072kB available aperture size.
May lead to reduced performance or incorrect rendering.
get chip id failed: -1 [9]
param: 4, val: 0
(EE) intel(0): failed to get resources: Bad file descriptor
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found

:-(.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
