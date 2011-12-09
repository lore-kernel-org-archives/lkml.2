Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1LISAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:00:45 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46336 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1LISAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:00:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kswrd98kmlYeQ+IAlbkBF
Date: Fri, 9 Dec 2011 10:00:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
Message-ID: <20111209180039.GR31337@atomide.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
 <1323382390-14892-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518604D7@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17518604D7@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [111209 08:56]:
> Linus Walleij wrote at Friday, December 09, 2011 7:01 AM:
> > 
> > What we could worry about is the amount of hard-coded chip data
> > which sort of correlates with the discussion with Tony on how to
> > provide DT info for pin control drivers.
> 
> My thinking here is that irrespective of whether the data in future chips
> is the same or different to the current chips, it's better in the driver.
> 
> For a given SoC, the data is static; it can never ever change.
> 
> Hence, there's no point parsing it from device tree; we end up with exactly
> the same data in the driver, yet have spent a bunch of time parsing it out
> from device tree instead of just embedding it into the kernel binary.
> 
> If parts of Tegra X and Tegra Y are similar, it should be possible to have
> them co-ordinate together and share the common data, and do whatever it
> takes to create the appropriate completed view before passing it back from
> tegraX_pinctrl_init() to the core. You could perhaps do it using /include/
> in the .dtsi file too, but I think allowing the SoC init code to unify the
> tables gives more flexibility; in your example below of the same data with
> different pin names, that'd be implementable with code without too much
> difficulty, but probably impossible with dtc since it has no macro/define
> support at present.
> 
> Also, the representation of the data in a .c file will likely be far
> smaller than in the .dtsi file, so this way saves space. Admittedly with
> a multi-SoC binary, you end up with all the large per-SoC data in the
> binary initially, so the space-savings aren't exactly seen, but it's
> all init data, so does get dumped soon after boot.
> 
> Another point here: I don't have to maintain a DT binding for the Tegra
> pinctrl driver this way, so if the next Tegra's pinmux HW is different,
> all I need to do is edit the driver, not be shackled by a need to keep
> the DT binding for it backwards-compatible. Although that said, I
> /think/ even an obvious DT binding derived from struct
> tegra_pinctrl_soc_data would be flexible enough for most things, perhaps
> with the addition of allowing config param field definitions for pins
> as well as groups.

What you're describing should be supported for sure.

IMHO the key issue here from pinctrl fwk point of view is: We want to
allow multiple data sources for describing the pinmux functions.

The data sources supported should be any combination of static platform_data,
DT data, loadable modules, and /lib/firmware. Then it's just a question of
using the most suitable method for each SoC.

Regards,

Tony
