Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1EUIdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:33:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1EUIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:32:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Biederman <ebiederm@aristanetworks.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
Date: Sat, 21 May 2011 10:32:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <4DD6FB9E.2050604@tilera.com> <BANLkTin5cE-u-J_88UC6ROxvwiMxR6Ro-Q@mail.gmail.com>
In-Reply-To: <BANLkTin5cE-u-J_88UC6ROxvwiMxR6Ro-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211032.51222.arnd@arndb.de>
X-Provags-ID: V02:K0:MnHBfv09uLlbUvSGIstpqU2Oq2GZFzU4CxGAg7AyrQz
 J+KhQfzNVaozfKm3SEIAi5YAaG17yINjZ4uy2ISYouM+ifv19r
 tSIrUEK7XWFlhR0Qtaurv09RYJd9PIi5U6d8LsKNzCdT81pqr/
 4INBzEiXFn2Aehl0Tm4oM8wxTMmShmcWykKym4ZpVa26xCCJHp
 T8PbVfiAtGOYYcQpUjgPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 May 2011 09:46:55 Eric Biederman wrote:
> On Fri, May 20, 2011 at 4:39 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> > On 5/20/2011 6:40 PM, Eric Biederman wrote:
> > The direct motivation for this case is to "impedance match" to the
> > hypervisor driver for this device, which handles sector management
> > internally, so the Linux device doesn't have to.  Having a 'flush' method
> > avoids excessive re-writes of the same sector for certain access patterns.
> > The only alternatives that I see are to rewrite the tile userspace tools,
> > but they are the way they are because the current model gives good
> > consistency guarantees for writing the boot rom in the presence of
> > arbitrary failure modes; or, to add something like a delayed timer event
> > that allows the Linux driver to notify the hypervisor driver that writes
> > are likely complete and it can write out the last sector.  Neither of these
> > are particularly attractive.
> 
> What is wrong with an mtd driver?
> 
> Looking a bit back into the conversation it appears clear that you are
> talking about something that resembles NOR flash with multiple sectors,
> etc.
> 
> eeproms have random byte access and are typically 256 bytes.  You devices
> doesn't sound anything like an eeprom.

MTD implies that you have low-level access to the NOR flash registers,
which this one doesn't. It's certainly not the right Linux interface
for a high-level flash device, and there is no precedent for this at
all in Linux.

We do have precedent for multiple interfaces that have the same
purpose as this one:

drivers/misc/eeprom/*
drivers/char/ps3flash.c
drivers/char/nwflash.c
drivers/char/bfin-otp.c
arch/powerpc/kernel/rtas_flash.c
drivers/sbus/char/jsflash.c

And then some more that I missed, plus the ones that use MTD.

	Arnd
