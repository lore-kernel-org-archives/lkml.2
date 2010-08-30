Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0H3H2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:28:48 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4744 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007Ab0H3H2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:28:47 -0400
Message-ID: <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>,
        "Thomas Gleixner" <tglx@linutronix.de>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com> <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain> <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Mon, 30 Aug 2010 16:28:41 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David
Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
<morinaga526@dsn.okisemi.com>; "David Woodhouse" <dwmw2@infradead.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Saturday, August 28, 2010 4:20 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> On Fri, Aug 27, 2010 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > B1;2401;0cOn Fri, 27 Aug 2010, Grant Likely wrote:
> >> [cc'ing Thomas Gleixner and David Woodhouse since this driver needs to
> >> get some data about the platform (to know what spi_devices are
> >> present) and I don't know how that is handled for x86 SoCs.]
> >
> > The best way to do all this platform specific configuration is to use
> > device tree. I really don't want to have x86/mach-xyz/board[A-Z]
> > horror, which is unavoidable when we don't get a sensible way to
> > configure the boards.
>
> I knew you were going to say that!  :-)
>
> Ohtak-san, for this patch I'd like you to drop the separate driver
> that only registers the spi_devices and just submit the core driver.

Sorry, I can't follow your discussion by lack of SPI knowledge.
Which the above mean that "spi_register_board_info"  moves to our spi_pch or
delete for our driver ?

> (You can of course keep the spi_device registration in your own tree
> for debug purposes).  I'll expect that the device will get
> instantiated using a device tree to determine which spi_devices are
> present.  The parsing of spi device tree data will be moving into the
> core spi subsystem code in the next merge window most likely, so it
> can all be handled transparently.
>
> > SFI was meant to provide a lightweight ACPI, but
> > now that device tree is generic and more platforms are using it, I
> > really want to standartize on that and forget SFI.
> >
> > That makes even more sense, as all these AMBA peripherals which are
> > duct-taped to a x86 core can be found in other SoCs with different
> > cores as well.
>
> Indeed.  BTW, Ohtak-san, is this spi bus device something brand new,
> or is it derived from an existing spi device?

Yes, Intel Topcliff is new concept device.


Thanks, Ohtake(OKISEMI)


