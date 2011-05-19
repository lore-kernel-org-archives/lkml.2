Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab1ESS2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:28:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807Ab1ESS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:28:21 -0400
Date: Thu, 19 May 2011 11:27:53 -0700
From: Greg KH <gregkh@suse.de>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: samsung-laptop backlight control not working
Message-ID: <20110519182753.GA23865@suse.de>
References: <BANLkTikwjL-3m110CcRs+-KLdZpH0rOTsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikwjL-3m110CcRs+-KLdZpH0rOTsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:18:16PM +0200, David Herrmann wrote:
> Hi
> 
> I tried the new samsung-laptop driver with samsung backlight support.

What kernel are you trying?  We have some recent patches to the driver
to try to resolve some of these issues on your laptop.

> It is detected as:
> [109282.931433] samsung_laptop: found laptop model 'N150P/N210P/N220P'
> 
> However, backlight support is kind of weird:
> "echo 1 >/sys/class/backlight/samsung/brightness"
> does not set brightness to 1 but instead reduces brightness for 1.
> That is, if my current brightness setting is 8, I need to call "echo 1
> >..." 7 times to get brightness value 1.
> 
> "cat /sys/class/backlight...."
> returns 1 after the first try, though.
> 
> "echo 3 >..."
> reduces brightness also for 1 but stops at brightness level 3 if I
> repeat the command.
> 
> dmesg shows the following for every "echo" I call:
> [110690.073783] ACPI: Failed to switch the brightness
> 
> Furthermore "echo 0 >..." doesn't disable backlight but instead
> behaves like a brightness setting below 1.

Yeah, don't echo 0 there, that doesn't work to well.  I have some
patches here that you can try if you want, just let me know.

> However, I know the following works on my machine:
> setpci -s 00:02.0 F4.B=255
> It accepts a setting between 0-255 and 255 is full brightness and 0 is
> backlight off.

Don't do that, the video driver will not like you as you are changing
things without telling the bios that something is really happening.

Of course you can continue to do this, it's just strongly not
recommended.

thanks,

greg k-h
