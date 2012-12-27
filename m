Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2L0QIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:08:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2L0QIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:08:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: anish kumar <anish198519851985@gmail.com>
Subject: Re: What does ISA/PCI really mean to ARM architecture?
Date: Thu, 27 Dec 2012 16:07:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Woody Wu <narkewoody@gmail.com>,
        kernelnewbies@kernelnewbies.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20121227082724.GA11775@zuhnb712.ap.bm.net> <CAMuHMdWbyrDaaV5TWiEafEpjuscoGKXKKYzNBw_CSSWYLbNaPQ@mail.gmail.com> <1356617960.5433.32.camel@anish-Inspiron-N5050>
In-Reply-To: <1356617960.5433.32.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201212271607.24201.arnd@arndb.de>
X-Provags-ID: V02:K0:qqmK2ArB5cYO6BjlWn0L6Q3EAvGud+4eL6dfHzns26a
 d+fgSnNoRBhjKSaboAq0jifRgNXD/4ATvvkdDMrTqwdV0WCncx
 s7R4aTQdHEzjJFsdnwTnbpkO5q5V+i7QMsidfFFhH5bCwC4JCn
 Yrb2O3v+pzlxMIlnz2Sv1Soj0GgCrIeq0rrREDp/YBB9lrltM7
 EFYNT15iDXafcSmPg+AAMAJg988qoShwpHUsoQtiunW4yvy/jg
 xf6IlxfMmPGwOI2pMCL9W4PPGpwBz6Ovq2iBGD3opvkW/IK5WL
 L2TkAijQFhZO4gDERSwfECGzQLYrXi3PuQ/zECXPvUsVrlNP1X
 EwnF68dETUFRiHN9vV7I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2012, anish kumar wrote:
> On Thu, 2012-12-27 at 10:51 +0100, Geert Uytterhoeven wrote:
> > On Thu, Dec 27, 2012 at 9:27 AM, Woody Wu <narkewoody@gmail.com> wrote:
> > > Can a peripheral chip that claims to be ISA or PCI device be used in a
> > > ARM based embedded system?  For these kind of chips, I only concern
> > > about the planar kind of devices, means they are not on a dedicated
> > > expansion card.
> > >
> > > From hardware point of view, to attach a ISA or PCI planar chip, is
> > > there any requirement need to fulfill on a ARM bard?
> arm AFAIK is only used in embedded system but ISA/PCI buses are
> generally part of 'big systems' and most of the times it refers to x86
> PC.

In the old days, there were a few ARM based systems that were closer
to what we think of as a PC, and that had actual ISA slots, or
(more commonly) PCMCIA, which is related to ISA.

Aside from that, there are and have been for a long time some ARM
systems that have PCI or PCIe slots.

Note that the distinction between ISA-style platform devices and
ISA add-on cards is a little fuzzy. The Kconfig option CONFIG_ISA
refers to the latter, but there are also ARM systems that only
have the former, e.g. for floppy controller.

> > > From Linux driver point of view, what are needed to support an ISA or
> > > PCI driver in ARM architecture?  More important, is ISA or PCI device a
> > > platform device?  If not, how to add these kind of devices in my board
> > > definition?
>
> AFAIK, Platform device is just a way to add a particular driver whose
> probe can't be called at runtime. Mostly platform device is part of
> system on chip.

Right. Note that some ISA devices (especially those that are typically
on-board) are platform devices as well, but PCI devices never are.

> > An ISA device is typically a platform device. For ARM, which uses device trees,
> Don't know much about ISA device to comment on this but people familiar
> with this can enlighten us as to the reason why it is platform device in
> detail.

Classic ISA has no way to probe the presence of a device, so platform
devices were introduced to handle those. There is also ISAPNP, which adds
PCI-like probing on top of ISA, but most ISA cards precede that standard.

	Arnd
