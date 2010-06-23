Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0FWKYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:24:21 -0400
Received: from legolas.restena.lu ([158.64.1.34]:41837 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0FWKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:24:19 -0400
Date: Wed, 23 Jun 2010 12:23:44 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Marek Vasut" <marek.vasut@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
Message-ID: <20100623122344.372e5f75@neptune.home>
In-Reply-To: <d1cda632f4cdb650a68119903473fbb4.squirrel@intranet.cs.nmsu.edu>
References: <alpine.LNX.2.00.1006211442350.13809@pobox.suse.cz>
	<d1cda632f4cdb650a68119903473fbb4.squirrel@intranet.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rick,

Please check how your driver behaves if the framebuffer is still in use
(open and/or mmapped) by some userspace process when you unplug the
keyboard.

Probably you will get hit be the same complaints from kernel I was seeing
with PicoLCD driver (see my patch http://lkml.org/lkml/2010/5/30/15 that
is expected to fix it on PicoLCD side, the refcounting part of the patch)

Bruno


On Tue, 22 June 2010 "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu> wrote:
> I've been waiting to resubmit until I get some of the userspace libraries
> and utilities a little more mature. There were some things I was exposing
> to sysfs that I didn't absolutely need, and some others that I needed to
> add.
> 
> The cairo and papyrus libraries are (preliminarily) fully working. Once I
> make sure I have everything the daemon will need I'll resubmit the driver,
> and once that is done I was planning on submitting the libs/utils to
> Fedora.
> 
> For now, I've been dropping Fedora 12/13 patches and kernel SRPMS here:
> http://miskatonic.cs.nmsu.edu/g13/
> 
> And the userspace libraries/utilities are at:
> http://g13.sourceforge.net
> 
> As for the g13fb on the G15... I would imagine it could be done, but I
> don't have a G15 so I can't say for sure.
> 
> If I had to guess I think you'll have to take the core functionality of
> the keyboard driver and extend it with the fb code in the _same_ driver if
> the keyboard and display use a similar design to the G13.
> 
> The G13 uses the same endpoint for both keyboard input and display
> messages, and since a USB endpoint can't be shared across drivers both
> will have to reside in the same driver.
> 
> --
> 
> Rick
> 
