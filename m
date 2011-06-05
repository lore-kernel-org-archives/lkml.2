Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1FEUz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:55:59 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:38427 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1FEUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
References: <20110605071725.26517.11573.stgit@ponder> <BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
 <20110605075458.GA2712@tarshish> <BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 5 Jun 2011 14:55:37 -0600
X-Google-Sender-Auth: _BrXHAu_sgiCSafvXK6i-GPNPH4
Message-ID: <BANLkTimgbxmBnTN9Sb55-hkbBi1AEfiPdg@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Baruch Siach <baruch@tkos.co.il>, Jassi Brar <jassisinghbrar@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 5:49 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, Jun 5, 2011 at 09:54, Baruch Siach <baruch@tkos.co.il> wrote:
>> On Sun, Jun 05, 2011 at 01:13:28PM +0530, Jassi Brar wrote:
>>> On Sun, Jun 5, 2011 at 12:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> > [repost: I had a typo on the spi-devel-general mailing list address]
>>> >
>>> > Sort the SPI makefile and enforce the naming convention spi_*.c for
>>> > spi drivers.
>>
>> [snip]
>>
>>> Though the spi_ prefix seems redundant considering the files are in
>>> 'spi' directory.
>>> Just a thought, no objection.
>>
>> When looking at the list of loaded modules (e.g. in an Oops message), the name
>> "spi_xilinx" is much more meaningful than just "xilinx", for example.
>
> Plus, when dropping the prefix, spi_xilinx.ko and gpio-xilinx.ko
> become the same...

Exactly.  We essentially have a flat namespace for modules, despite
the fact of them being organized into directories.  At least for the
subsystems I maintain, I'd like to have a consistent prefix for that
reason.

> So now we have spi_<name>.c (with underscore) and gpio-<name>.c (with dash)?
> And other subsystems go with <name>-<type>.c instead, e.g.
> drivers/mfd/wm831x-spi.c?

On a brief survey of drivers:

apci: *.c
ata: pata_*.c, sata_*.c
atm: *.c
block: *.c
bluetooth: *.c
crypto: *.c
dma: *dma.c
gpio: gpio-*.c (after applying my patch)
hid: hid-*.c
hwmon: *.c
i2c: i2c-*.c
ide: *.c and ide-*.c
input: *.c
leds: leds-*.c
mca: mca-*.c
md: largely dm-*.c
mfd: *.c
mmc: *.c
mtd: *.c
net: *.c
rtc: rtc-*.c
scsi: *.c and scsi_*.c for core code
spi: (before patch) mix of spi_*.c and *_spi.c and *.c
uio: uio_*.c
virtio: virtio_*.c
wdt: *wdt.c and *_wdt.c

So, in this (admittedly incomplete) survey, I see 5 users of the
"prefix_" pattern, 8 of the "prefix-" pattern, a small number using a
suffix, and a whole lot without any pattern at all.  Personally, I
prefer the using a prefix with a '-', but in the spi directory there
was already a number of drivers using '_', so it was smaller impact to
change to using that instead of a dash.  If people don't think it is a
big deal though, then I'll change it to '-' to match the gpio change.

g.
