Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2HGTcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:32:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46062 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2HGTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:32:40 -0400
Message-ID: <50216D52.3030402@gmail.com>
Date: Tue, 07 Aug 2012 21:32:34 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 0/6] ARM: dove: DT support for Marvell Dove
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com> <201208061402.22815.arnd@arndb.de> <CABJ1b_S6jRW9P7ygs7LPztbx1zW-u=gD1kk0UYbgBrHdvsaOeA@mail.gmail.com> <20120807165350.GG18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120807165350.GG18957@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 06:53 PM, Russell King - ARM Linux wrote:
> I've recently pushed a fix into mainline (and stable) for VFP support
> with Thumb instructions.  I noticed that the Cubox kernel had a different
> fix, this "different" fix will need to be removed when Cubox folk update
> to the next kernel from mainline.

Russell,

I read about that fix but honestly, that is way to deep into ARM
architecture for me. All I realized while having my Cubox is that the
supplied kernel tree is very messy and on Debian wheezy/armhf almost
all applications started over ssh -X fail with segfault. I was hoping
that bringing the cubox into mainline kernel tree will help here -
and luckily the (hacking) community is growing!

> Video support, not great.  The supplied Ubuntu Lucid stuff install
> (including the latest dev kernel from the solid-run folk) doesn't work
> with any of the tree HDMI devices I've tried it with:

HDMI is another topic that I want to work on as soon as the main SoC
stuff is ported over to mainline. HDMI output actually is done by some
nxp HDMI transmitter that translates the rgb 888 video from lcd controller
on dove. AFAIR the HDMI transmitter code is "open", i.e. free to clean up
and port. I haven't looked closely into lcd yet but on Cubox the lcd pixclk
comes from an external clk chip (si5351a) that I have a quite ready driver
for. The existing driver does a table based setup of the plls and does not
hit 148.5 MHz precisely. The driver I wrote is based on an AN from SiLabs
and is also already based on common clk framework.

> . A LCD PC monitor with HDMI input.  If the monitor is disconnected, the
>    Cubox booted, and the monitor connected, you get a picture, but you
>    lose the top, left, bottom and right of the display off the side of the
>    monitor.  No amount of adjusting on the monitor fixes this.

There have been many reports of people no being able to get proper resolutions
with the original kernel setup. I know there are people working on gfx support
and xbmc. Maybe you hit the solid-run.com forums and have a look there.

> What is obvious is that there is no HDMI hotplug support and reconfiguring
> of the display.  So, I've been investigating the Linux DRM/DRI support -
> both the kernel and X11 side, and I have something that is getting close
> to being ready.  Last night I finally disabled the kernel dovefb driver,
> and have X11 using solely my new DRM driver.

Great, keep me posted and I ll be happy to test it.

> However, this won't be using the on-chip mpeg decoding (yet).  CPU
> usage sits at around 30% while vlc playback is running.

The bad thing with GLES and video decoding is that it all relies on
some dirty closed source user space libraries. But again, as I am not
that familiar with gfx and decoding drivers, I didn't look into that.

Sebastian
