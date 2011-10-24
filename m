Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1JXUJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:09:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34449 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1JXUJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:09:38 -0400
Date: Mon, 24 Oct 2011 22:09:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Roland Kletzing <devzero@web.de>
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Artem.Bityutskiy@nokia.com
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
Message-ID: <20111024200927.GH5632@1wt.eu>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003> <20111024055705.GA4020@1wt.eu> <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,

On Mon, Oct 24, 2011 at 09:32:42PM +0200, Roland Kletzing wrote:
> Yes, i think accidentally insmodding  "mtd_stresstest" has just wiped it, 
> not killed.
> The problem is, that it is important stuff for booting and you can`t pull 
> it out and
> re-write externally, like a disk. Sorry, i that was probably not clearly 
> stated.
> 
> Anyway - what would people think if linux had a kernel module  which wipes
> /dev/sda1 when loaded ? :)

I totally agree. And on some machines, you might have mtd0 mapped to a
real block device.

> >I got one Iomega Iconnect with a faulty flash that I got replaced for a
> >good one, so it's more likely the case here.
> 
> Yes, i could give debricking with JTAG a try. But what about the cost for 
> the JTAG
> and the work to be spent with it? I could buy another Dockstar for that.....

it's cheap, download openocd and make a Wiggler cable. It requires very
little hardware. I don't see why it wouldn't work, I've done that to try
to port Linux to a miniature ARM platform a few years ago (it was pretty
funny). You just need one rainy sunday afternoon.

> static int dev;   <-!
> module_param(dev, int, S_IRUGO);
> MODULE_PARM_DESC(dev, "MTD device number to use");
...
> My kernel log showed:
> 
> mtd_stresstest: MTD device: 0
> mtd_stresstest: MTD device size 1048576 etc...

Ooops.

> So, apparenly the module accidentally picked mtd0 instead of exiting 
> cleanly (as
> i did not pass a device number)
> 
> I`m not a programmer, but doesn`t look that like an "unitialized variable" 
> issue ?

You're pretty right indeed ! I think the code has only be tested with
devices that ought to be killed, otherwise the author would have noticed
it quickly.

> If yes, then i would call my Dockstar "victim of a bug".

One more reason to try to resurrect it ;-)

Cheers,
Willy

