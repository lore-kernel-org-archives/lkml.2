Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2LCVTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:19:14 -0500
Received: from science.horizon.com ([71.41.210.146]:28054 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751034Ab2LCVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:19:13 -0500
Date: 3 Dec 2012 16:19:11 -0500
Message-ID: <20121203211911.20156.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: alan@linux.intel.com, chris@the-brannons.com, gregkh@linuxfoundation.org,
        jslaby@suse.cz
Subject: Caps lock XOR on multiple keyboards?
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Not sure who owns this; Cc: to the last few people to touch
drivers/tty/vt/keyboard.c.)

I happen to have both a PS/2 and USB keyboard plugged, in, but was
noticing that the caps lock key seemed inverted.  When the LED was off,
I got all caps (unless I used shift), while when it was on I got normal
lower-case letters.

This quite confused me, until I looked over and saw that someone had
hit caps lock on the PS/2.

Experimenting, it seems that each keyboard has its own caps lock LED
state, and the XOR of the two controls the case of the letters.

The corresponding shift keys have a shared logical state which depends
on who last had a transition.  Holding down left-shift on one can be
cancelled by pressing and releasing left-shift on the other.  (But
left & right shift are tracked separately.)

It would make more sense if each keyboard's caps lock LED controlled
the effect on its keys.  Either give each keyboard a completely separate
caps lock state, or toggle both LEDs when either caps lock is pressed.

Perhaps the answer is "It's too much work to fix; stop doing something
so stupid", but I thought I'd at least mention it.

(Er... it appears that my XOR description was incomplete.  I now have
the keyboard system in a state where *one* caps lock LED has to be on
to get normal lower-case letters.  I was playing with down1/down2/up1/up2
combinations, but I'm not quite sure what happened...)
