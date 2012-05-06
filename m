Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2EFOXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 10:23:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46894 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2EFOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 10:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <201205051921.13209.arnd@arndb.de>
References: <20120503144645.6390.62303.sendpatchset@w520>
	<201205050722.45500.arnd@arndb.de>
	<201205052108.03001.rjw@sisk.pl>
	<201205051921.13209.arnd@arndb.de>
Date: Sun, 6 May 2012 23:23:31 +0900
Message-ID: <CANqRtoRHekxkbpW9diJy27d1a1EofeyotLFfgN4tcabmJxZmsA@mail.gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 4:21 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 05 May 2012, Rafael J. Wysocki wrote:
>> Now, if you insist on us having a separate mach- directory for every platform
>> (SoC), we can do that I think, but then we should start with splitting up the
>> existing mach-shmobile into a number of SoC-specific directories rather than
>> adding new mach- directories for random new parts, because that goes against
>> our development history to date, which is important too IMHO.
>
> All the chips in there so far share a common ancestry and they all use a
> significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
> sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
> uses none of those and apparently was developed by NEC before the merger with
> Renesas.

Please allow me to jump in here for a second.

You are right that none of the current in-tree SoCs were developed by
NEC, but exactly which bits that end up inside the SoC varies quite a
bit. The r8a7779 is for instance in the R-Car line which I believe for
some reason has more similarities with ex-NEC chips. The pinmux is not
that different from Emma mobile. Some timers and serial ports are
shared with other SoCs but many other IP blocks have nothing in common
with other mach-shmobile SoCs. But I sort of fail to see why this
matters since it's stuff kept outside of arch/arm anyways. As you
probably know the r8a7779 SoC is already merged in mach-shmobile but
we can of course move it out if that helps.

Also, the more the merrier. Apart from NEC the current set of SoCs
contain IP from Renesas which historically is a mix of Hitachi and
Mitsubishi. Plus the regular set of ARM and SGX IP of course, like
most vendors these days.

So if all these things are moved out of arch/arm (which I believe is
the right way forward) then what is the point of having mach
directories at all? In the end it's some random ARM IP with I/O
devices hanging off it. With that in mind i'd rather work on putting
the Emma Mobile stuff in a common arch/arm location than create yet
another separate directory for something that isn't really special at
all.

Cheers,

/ magnus
