Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0H0SyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:54:05 -0400
Received: from www.tglx.de ([62.245.132.106]:44586 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0H0SyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:54:03 -0400
Date: Fri, 27 Aug 2010 20:53:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
In-Reply-To: <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Fri, 27 Aug 2010, Grant Likely wrote:
> [cc'ing Thomas Gleixner and David Woodhouse since this driver needs to
> get some data about the platform (to know what spi_devices are
> present) and I don't know how that is handled for x86 SoCs.]

The best way to do all this platform specific configuration is to use
device tree. I really don't want to have x86/mach-xyz/board[A-Z]
horror, which is unavoidable when we don't get a sensible way to
configure the boards. SFI was meant to provide a lightweight ACPI, but
now that device tree is generic and more platforms are using it, I
really want to standartize on that and forget SFI.

That makes even more sense, as all these AMBA peripherals which are
duct-taped to a x86 core can be found in other SoCs with different
cores as well.

Thanks,

	tglx
