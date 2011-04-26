Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1DZV3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:29:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1DZV3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:29:44 -0400
Date: Tue, 26 Apr 2011 23:29:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: Wonkiness with keyboard adapter - not sure if it's in USB or
 input systems
In-Reply-To: <23191.1303845136@localhost>
Message-ID: <alpine.LNX.2.00.1104262319240.12035@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1104261453300.2035-100000@iolanthe.rowland.org> <23191.1303845136@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Valdis.Kletnieks@vt.edu wrote:

> > > Bus 001 Device 006: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
> 
> > Have you tried testing the adapter by plugging it in after the system 
> > is running?
> 
> It works fine at the Grub screen.
> 
> It *doesn't* work for the kernel when it initially starts up, even though a few
> seconds ago the hardware worked just fine.
> 
> It *does* work after I've unplugged/replugged it - I've tested both the USB
> side and the PS2 side, in either case it starts working.
> 
> I'm not sure what difference "plug it in after it's running" and "unplug/
> replug" will have. I suppose I could test that, but I'm suspecting the results
> will be "it works fine after plugging it in once the kernel is up".

It seems like the BIOS handover of the USB input device doesn't work 
properly.

The way things usually work in such situations -- BIOS is able to 
understand USB input devices in a very basic mode (hidp) and translate the 
events into PS/2-looking events, so that things like grub (which don't 
understand USB HID) are able to see keyboard events -- BIOS presents those 
as PS/2 devices.

Once kernel is booted, it takes over devices in this 'legacy' mode from 
BIOS, and initializes them properly as USB input devices.

Seems like this process is broken on your system. Could you please try to 
disable legacy USB emulation in your BIOS, and see if the problem 
persists? (it will make USB keyboard unavailable in grub).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
