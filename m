Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1CKSzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:55:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44003 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1CKSzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=J7auxa3hrDbPV5WWP8HQZO3IC6H1oh6gnYUQyPcATWWPVz+uGXgmxQbcG6YHQdpLzQ
         +Rk5ZlmCvh2FzJqLlnWeHUbEBG6Wzikit3NWtg2CzIJS8X7zrOzFtE5kY9fMQQusyoAx
         xbE2SlOe2r3XSYg2yCaRznMuyuEdQjh8QWj1c=
MIME-Version: 1.0
Date: Fri, 11 Mar 2011 13:55:39 -0500
Message-ID: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
Subject: How to use gma500 framebuffer driver?
From: Greg Brigley <gbrigley@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to test the poulsbo/gma500 driver recently added to
drivers/staging in linux-next, and having trouble.  I'm hoping someone
can help me get going (or let me know if I should be asking somewhere
other than the main kernel list.)

I did a git clone of linux-next. I got errors trying to build the
gma500 driver on the head, so I did a checkout to
0e83f46d3869a5255a04b875bb885bd141a609ef, from Feb 26 - the last
commit on drivers/staging/gma500, and now I can build successfully,
but have not succeeded in producing video output.

I guess I'll start by saying what I'm trying to do, to make sure I'm
not misguided in trying this in the first place.  I want to run Xfbdev
and drive both an LVDS and HDMI display at the same time (mirrored).
I don't need 2d or 3d acceleration.  I don't see an indication that
anyone else has tried mirrored displays with this driver, and I don't
mind being the first, but should it work in theory?  If it's not
supported, would it be difficult to add?

My hardware is an embedded system, containing one of these:
http://www.radisys.com/Products/COM-Express/COM-Express-Modules/Procelerant-CEZ5XT.html.
 I've successfully driven the two displays using Ubuntu 10.10 with
added poulsbo drivers and other pieces, so I know the hardware is good
and can work this way if the driver supports it.

So here are my questions for those who have used the staging driver:
* Should I be compiling it as a module, or as part of the kernel?
* If I'm compiling it as part of the kernel, what kernel parameters do
I use to activate it?   I tried to guess based on past experience with
non-DRM framebuffer drivers, but I get the impression that DRM
framebuffers are different, and I don't really have any experience
there.
* If I'm compiling it as a module, is there some sort of incantation
to make the framebuffer device show up when I insert the module?
Currently, when I insmod psb_gfx.ko, nothing appears in /proc/fb, or
in /dev.  I'm using udev.  If I do "mknod /dev/fb0 c 29 0", then both
fbset and Xfbdev give me "no such device" errors.

I'll stop there for now, in case I'm entirely on the wrong track, but
I'm happy to provide more detail if anyone is able to help.  I'm very
motivated to get this working, and if there's anything I can do to
help with development or testing of the driver going forward, I'd be
happy to do so.

Thanks,
Greg
