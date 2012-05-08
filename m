Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2EHUMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:12:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50148 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2EHUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:12:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Tue, 8 May 2012 20:12:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205051921.13209.arnd@arndb.de> <CANqRtoRHekxkbpW9diJy27d1a1EofeyotLFfgN4tcabmJxZmsA@mail.gmail.com>
In-Reply-To: <CANqRtoRHekxkbpW9diJy27d1a1EofeyotLFfgN4tcabmJxZmsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205082012.12514.arnd@arndb.de>
X-Provags-ID: V02:K0:KTCJHmIi1IYiJTf3zj1sA9qZyjs4OaXwuqNYD87R3Mh
 4fgTADZHD7ouyRgquOJpswJnE3rqMfRTdvgvCcwCmegS5Joz37
 pTAovyXcoWSE7mD3Xw1YEMSJJXTn0Bmv6FTm2TriPGKQQLSpo3
 4XAtdrFpsiigJ6YPS2mckwAMACvAPaQF36wCADDD2txrYp+Vcm
 9ILnCUCvvg3FARZd4wiRmvmJKxifHfv5bc/6v5aN3cziI4E01v
 S1KaqQHPPTwI16+aUMFc43n4x74IxmK1MOh+g13cuasW3dJNq8
 Hciq+2w5K2nwIA+SMkaUMlOgYzTB6/PurVTSetjyi6JebzQeXA
 6XmNVB8fsXJYGY2/wqso=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 May 2012, Magnus Damm wrote:
> Please allow me to jump in here for a second.
> 
> You are right that none of the current in-tree SoCs were developed by
> NEC, but exactly which bits that end up inside the SoC varies quite a
> bit. The r8a7779 is for instance in the R-Car line which I believe for
> some reason has more similarities with ex-NEC chips. The pinmux is not
> that different from Emma mobile. Some timers and serial ports are
> shared with other SoCs but many other IP blocks have nothing in common
> with other mach-shmobile SoCs. But I sort of fail to see why this
> matters since it's stuff kept outside of arch/arm anyways. As you
> probably know the r8a7779 SoC is already merged in mach-shmobile but
> we can of course move it out if that helps.

I want the structure to make sense and be consistent so that anyone
who works with a lot of platforms knows where to find stuff and can
work on all the platforms. Simplicity sometimes trumps consistency,
but both are important.

The r8a7779 SoC is indeed an interesting case, it seems to fit
well into shmobile because you use some of the same devices (e.g.
sh-sci and the clock code). If you think there are lots of
commonalities with the new one, it's probably fair to put them
in the same directory even when that means we also have completely
unrelated stuff in there now. I would still prefer having separate
directories, but I'll leave it up to you as long as you put
an explanation about the history into the changeset comment.

One thing is I really don't like is when I get the impression that
people are trying to cheat and hide important facts from the upstream
maintainer in order to improve their chance of getting stuff included.
The best way to avoid giving that impression is to add as much
information as possible about why you do things in a certain way.

> So if all these things are moved out of arch/arm (which I believe is
> the right way forward) then what is the point of having mach
> directories at all? In the end it's some random ARM IP with I/O
> devices hanging off it. With that in mind i'd rather work on putting
> the Emma Mobile stuff in a common arch/arm location than create yet
> another separate directory for something that isn't really special at
> all.

We're heading that way for 64 bit ARM, but it needs more work. When
all drivers (irqchip, clock, pinctrl, ...) have been moved out of arch/arm,
I guess a lot of simple platforms become a single source file with just
one DT_MACHINE_START statement (or something even simpler), and then
we can put them into a common directory.

	Arnd
