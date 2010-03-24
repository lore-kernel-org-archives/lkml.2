Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0CXXBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:01:20 -0400
Received: from legolas.restena.lu ([158.64.1.34]:46054 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0CXXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:01:12 -0400
Date: Wed, 24 Mar 2010 23:37:07 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v3 0/6] hid: new driver for PicoLCD device
Message-ID: <20100324233707.7243b04d@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for PicoLCD USB HID device adding support for
the various features in different patches so each patch concentrates
on a device class.

Changes since revision 2:
- drop most inline keywords
- use mutex to protect question-wait-for-answer requests
- use mutex to protect flash erase+write+write sequence
- add support for simulated 8-bit mode (advertised grayscale and
  translated by "pixel & 0x80 ? 1 : 0"
    Explaining Jaya's curiosity about my choice, there seem to be
    (near) no userspace application willing to operate on a 1bpp
    framebuffer. Simulated 8bpp tested with links (dfbsee has
    unrelated? issues, fbv seems to always want color map for 8bpp
    even for grayscale...)
    Is it correct to call "8bpp grayscale" TRUECOLOR? If not, what's
    the right FB_VISUAL_* name?
- fix a couple checkpatch warnings/errors
  (there are multiple "longer than 80 char" lines left though
   I don't think it's worth/readable to kill them all)
- extract version check into a separate function
- do direct keycode lookup
- replace sysfs_{create,remove}_file with device_{create,remove}_file
- correct initial update of framebuffer


I've not changed the Kconfig part from v2 as an attempt to add
sub-options which would select FB, LCD_CLASS, BACKLIGHT_CLASS
or LEDS_CLASS ended up in kbuild to complain about a dependency loop
for FB.
I'm wondering why I didn't get such a loop for first revision when
HID_PICOLCD did select everything...
As this is build-cosmetic it can be looked into at a later time.


The series depends on my previous patch adding HID suspend support
(I've not yet looked at improving it). Except that one the series is
on top of 2.6.34-rc2.
Note that debugfs registration is wrong on hotplug (a fix for this
one is waiting in Jiri's upstream branch:
  http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=4da361b69102cdffe73006771eae7504d2cb8736 )

Bruno
