Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0IJE4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:56:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35042 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0IJE4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:56:02 -0400
Date: Thu, 9 Sep 2010 22:55:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Message-ID: <20100910045558.GA8436@angua.secretlab.ca>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
 <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 10:58:38PM +0200, Linus Walleij wrote:
> 2010/9/3 Masayuki Ohtake <masa-korg@dsn.okisemi.com>:
> 
> > Each instance of our SPI device has the same vendor ID and device ID.
> > Thus, I think it is impossible to be called probe() for each instance.
> 
> Looking at you latest patch it appears you could :-)
> That solves the problem pretty nicely.

Actually, it doesn't look like he did.  It looks to me that the
ability to support multiple spi bus instances on a single PCI device
has simply been removed.  I don't know if that is because it simply
isn't needed yet, or if it is because Ohtake-san doesn't quite
understand what were suggesting.

Regardless it doesn't matter.  When or if the driver does need to be
modified to support multiple instances, it is a relatively straight
forward matter to refactor the current code into a platform_driver,
and create a new pci_driver that simply registers the matching
platform_device for each spi bus instance supported by the device.

g.
