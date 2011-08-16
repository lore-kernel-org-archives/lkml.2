Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1HPNik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:38:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1HPNii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:38:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Tue, 16 Aug 2011 15:37:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kenneth Heitke <kheitke@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <201108111455.56319.arnd@arndb.de> <20110812164608.GC28150@sirena.org.uk>
In-Reply-To: <20110812164608.GC28150@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201108161537.28612.arnd@arndb.de>
X-Provags-ID: V02:K0:Z1ewSDEFV34FxCBm+HS2VZHAvQmvlE8e0NkiW5V7V5g
 Of2V9oesx7+hNqkQTFIQEMxEPe38ZrMvSCeUx8dyROqIWQPh0I
 kFcPU0eViV38EFrnrk4WeL9eLA9FFT5Y0UamIfzi/URHAbYzeh
 d38X1b0MnxPmWLZQfHQJ7us9pCg0lJjpVGHDxWVEU5TPhBG+QK
 yfQay8885sKwV4pnQ0xDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 August 2011, Mark Brown wrote:
> On Thu, Aug 11, 2011 at 02:55:55PM +0200, Arnd Bergmann wrote:
> > On Thursday 11 August 2011, Kenneth Heitke wrote:
> 
> > > +EXPORT_SYMBOL_GPL(slim_add_device);
> 
> > I don't think this should be exported: AFAICT, the set of slim_devices
> > is a property of the platform, so I don't see how any other device driver
> > would add another device.
> 
> The platform may be comprised of multiple hardwaare modules with
> functionality on daughtercards which can be probed at runtime.  You may
> also find someone constructing a PCI card or something with a slimbus
> controller on it at some point.

This is theoretically true, but IIRC David mentioned that the bus is
only present on few SoCs and has since been abandoned in favor of standard
busses for new devices.

> > > +EXPORT_SYMBOL_GPL(slim_register_board_info);
> 
> > We are trying to gradually convert platforms that have hardcoded device
> > lists and cannot probe devices by looking at the hardware over to using
> > device tree files that list all the devices.
> 
> > I think that this would work well for slimbus and should be done
> > right from the start. This means however that you should not
> > register a "board_info" but instead change the slim_register_controller
> > function so that it adds all devices listed as children of the
> > controller in the device tree.
> 
> It seems a bit extreme to prevent anyone implementing a subsystem for
> their platform until they've converted it into device tree.  Though with
> slimbus it should be at least somewhat probeable IIRC?

>From what I've heard (and seen in the code), there is no support for
probing, just like in I2C.
The platform is in the process of getting converted to device tree
already, the first patches were posted on Saturday. I don't know what
the timeline is for this, or how many board with slimbus are supported
in mainline or still waiting to get merged, but my guess is that the
bulk is still out of tree. If that's true, it's definitely cleaner to
convert it over to device tree before merging, instead of having to
change all the board files again when doing the conversion.

	Arnd
