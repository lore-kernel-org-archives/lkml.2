Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274Ab2CMJnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:43:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46424 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759363Ab2CMJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:43:21 -0400
X-Sasl-enc: VYZoK0pcz5D2dn7ROw4UjXDru+9B4AJZmzR3EkmvlEEA 1331631800
Message-ID: <4F5F1776.4020904@ladisch.de>
Date: Tue, 13 Mar 2012 10:46:30 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Triple implementation of WM8766 and quadruple WM8776!
References: <201203122241.12234.linux@rainbow-software.org>
In-Reply-To: <201203122241.12234.linux@rainbow-software.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> I'm trying do implement support for Philips PSC724 Ultimate Edge card, which
> is based on VT1722 + WM8776 + WM8766 chips. Found that the best file to base
> my work on is sound/pci/ice1712/se.c (as SE-200PCI card contains both WM8776
> and WM8766 chips).
>
> While doing this, found that there are three implementations of WM8766 codec
> control, two of them in the same driver(!):
> sound/pci/ice1712/se.c
> sound/pci/ice1712/prodigy_hifi.c
> sound/pci/oxygen/xonar_wm87x6.c (+sound/pci/oxygen/wm8766.h)
>
> And WM8776 status is even worse, there are four implementations, again two
> being in the same driver:
> sound/pci/ice1712/se.c
> sound/pci/ice1712/maya44.c
> sound/pci/oxygen/xonar_wm87x6.c (+sound/pci/oxygen/wm8776.h)
> sound/soc/codecs/wm8776.c (this one being official and stand-alone module but
> it does not seem to be usable as a part of sound card driver)

The ALSA SoC framework differentiates between three kinds of drivers:
codec, platform (controllers like the VT1722), and machine (in your
case, the wiring on the PSC724).  When I wrote the oxygen driver,
I didn't use ASoC because it didn't support multiple codecs per card
at that time (now it does).

I'd suggest to use ASoC, except that ice1724 is not an ASoC platform
driver, so you'd have to duplicate it.

All the non-ASoC drivers mix codec and machine drivers in the same file.
In the long term, ice1712 and oxygen should be converted to use ASoC,
but that would be a lot of effort if regressions are to be avoided.

I'd suggest to move the common parts of the three ice1712 drivers into
separate files.  You could make the interface of those files similar to
ASoC codec drivers to make later porting easier.


Regards,
Clemens
