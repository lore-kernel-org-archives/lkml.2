Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0HaGDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:03:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39402 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0HaGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <001501cb48ae$262d8d60$66f8800a@maildom.okisemi.com>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
 <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
 <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com>
 <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com> <AANLkTikpj6Q6QjFn4S9cYfBiKbMNQB_N2ptHEAvfW0wb@mail.gmail.com>
 <001501cb48ae$262d8d60$66f8800a@maildom.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Aug 2010 00:03:11 -0600
X-Google-Sender-Auth: NHlKoR7vxdPPgZGxk517dVUmpJU
Message-ID: <AANLkTi=Q_16S4+AGk=BjiKHZjjeon=-OmPz4QKmRZ+h2@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 7:45 PM, Masayuki Ohtake
<masa-korg@dsn.okisemi.com> wrote:
> ----- Original Message -----
>> From: "Grant Likely" <grant.likely@secretlab.ca>
>> To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
>> Cc: "Thomas Gleixner" <tglx@linutronix.de>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David
> Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
> <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
> <morinaga526@dsn.okisemi.com>; "David Woodhouse" <dwmw2@infradead.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
>> Sent: Tuesday, August 31, 2010 3:23 AM
>> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
>>
>>
>> On Mon, Aug 30, 2010 at 1:28 AM, Masayuki Ohtake
>> <masa-korg@dsn.okisemi.com> wrote:
>> > ----- Original Message -----
>> > From: "Grant Likely" <grant.likely@secretlab.ca>
>> > To: "Thomas Gleixner" <tglx@linutronix.de>
>> > Cc: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>;
> "David
>> > Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
>> > <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
>> > <morinaga526@dsn.okisemi.com>; "David Woodhouse" <dwmw2@infradead.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
>> > Sent: Saturday, August 28, 2010 4:20 AM
>> > Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
>> >
>> >
>> >> On Fri, Aug 27, 2010 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> > B1;2401;0cOn Fri, 27 Aug 2010, Grant Likely wrote:
>> >> >> [cc'ing Thomas Gleixner and David Woodhouse since this driver needs to
>> >> >> get some data about the platform (to know what spi_devices are
>> >> >> present) and I don't know how that is handled for x86 SoCs.]
>> >> >
>> >> > The best way to do all this platform specific configuration is to use
>> >> > device tree. I really don't want to have x86/mach-xyz/board[A-Z]
>> >> > horror, which is unavoidable when we don't get a sensible way to
>> >> > configure the boards.
>> >>
>> >> I knew you were going to say that! :-)
>> >>
>> >> Ohtak-san, for this patch I'd like you to drop the separate driver
>> >> that only registers the spi_devices and just submit the core driver.
>> >
>> > Sorry, I can't follow your discussion by lack of SPI knowledge.
>> > Which the above mean that "spi_register_board_info" moves to our spi_pch or
>> > delete for our driver ?
>>
>> I mean remove drivers/spi/spi_pch_device.c and the related Kconfig
>> bits from this patch.
>> The spi_device registration is a separate task
>> which should be submitted in a separate patch, and would be better
>> handled in either platform support code or with a device tree.
>
> How should we register spi_device information ?
> Could you show reference driver ?

Well, to start with, the registration code currently in
spi_pch_device.c is probably pretty much unusable for any platform
other than the development board that you're working on.  Every
machine using the topcliff chip will have a different set of spi
devices attached to the bus.  So, you'll need a method for having a
different set of registrations depending on the machine.

Traditionally with ARM systems, there is a separate .c file for each
machine (see arch/arm/mach-*/*.c) which registers the expected
devices.  In PowerPC the spi devices are described in a device tree
file (arch/powerpc/boot/dts/*) which the kernel will parse and
register the devices it finds.  x86 doesn't support either approach
because traditionally the kernel is either able to detect the
hardware, or it can get information from the BIOS (which doesn't work
for embedded x86).

The x86 maintainers want to adopt the device tree approach for
describing devices.  Using device tree data in an spi bus driver is
easy.  All that is required is to supply the of_node pointer to the
spi bus before registering it.  Search for 'of_node' in
drivers/spi/mpc52xx_spi.c for an example.  However, device tree
support is not yet available for x86, so there is still some
development that needs to be done.

Regardless, the topcliff spi driver can still be merged into mainline
without the spi_device registration code, and you can keep your
personal copy of spi_pch_device.c for testing while the details about
device tree support for x86 get worked out.

g.
