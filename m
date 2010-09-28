Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0I1Q2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:28:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39532 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754144Ab0I1Q2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:28:23 -0400
Date: Tue, 28 Sep 2010 09:28:40 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        richard.rojfors@mocean-labs.com, meego-dev@meego.com,
        ML linux-kernel <linux-kernel@vger.kernel.org>, Qi <qi.wang@intel.com>,
        andrew.chih.howe.khor@intel.com, gregkh@suse.de,
        Yong Y <yong.y.wang@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, joel.clark@intel.com,
        margie.foster@intel.com, kok.howg.ewe@intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-ID: <20100928162839.GA10739@opensource.wolfsonmicro.com>
References: <4C80D3C8.9020204@dsn.okisemi.com>
 <20100903134827.GA7614@rakim.wolfsonmicro.main>
 <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com>
 <201009272338.23762.vapier@gentoo.org>
 <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com>
 <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com>
 <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
 <20100928052950.GB5878@sirena.org.uk>
 <001201cb5ed7$6117cb40$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201cb5ed7$6117cb40$66f8800a@maildom.okisemi.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 03:35:39PM +0900, Masayuki Ohtake wrote:

>     gpio->base = (u32)chip->pch_gpio_base_address;

This is the number that will be assigned to the first GPIO if the chip
registers successfully.

>     gpio->ngpio = 12;

This is the number of GPIOs your chip has.

>     chip->pch_gpio_base_address = pci_iomap(pdev, 1, 0);

This initialisation is incorrect and is likely to fail.  gpiolib knows
nothing of how your chip is controlled, the base is the base for the
GPIO numbers used to access GPIOs in gpiolib.  Please refer to other
gpiolib drivers for examples of how to use the gpilib APIs.
