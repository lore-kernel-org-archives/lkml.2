Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1JTULE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:11:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23909 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1JTULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:11:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YhrHlm3zrBGkU61FA53mk
Date: Thu, 20 Oct 2011 13:10:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111020201054.GN3842@atomide.com>
References: <20111019144734.GI18713@sirena.org.uk>
 <20111019150448.GB32007@S2100-06.ap.freescale.net>
 <20111019151031.GA4275@opensource.wolfsonmicro.com>
 <4E9F9892.9070007@ti.com>
 <20111020094140.GK18713@sirena.org.uk>
 <20111020162743.GB31337@atomide.com>
 <20111020164006.GA10155@sirena.org.uk>
 <20111020170534.GC31337@atomide.com>
 <20111020172218.GE31337@atomide.com>
 <20111020195734.GB17384@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020195734.GB17384@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [111020 12:23]:
> On Thu, Oct 20, 2011 at 10:22:19AM -0700, Tony Lindgren wrote:
> 
> > Hmm, actually, can't we just pass the board specific configuration in
> > the board specific .dts file and then it gets merged in with the
> > arch independent DT node?
> 
> I don't understand what an "arch independent DT node" would be?

Well that's the standard non-Linux specific parts. Basically what's
in the $Subject patch minus what you commented on earlier:

> +- regulator-change-voltage: boolean, Output voltage can be changed by software
> +- regulator-change-current: boolean, Output current can be chnaged by software
> +- regulator-change-mode: boolean, Operating mode can be changed by software
> +- regulator-change-status: boolean, Enable/Disable control for regulator exists
> +- regulator-change-drms: boolean, Dynamic regulator mode switching is enabled
> +- regulator-mode-fast: boolean, allow/set fast mode for the regulator
> +- regulator-mode-normal: boolean, allow/set normal mode for the regulator
> +- regulator-mode-idle: boolean, allow/set idle mode for the regulator
> +- regulator-mode-standby: boolean, allow/set standby mode for the regulator
> +- regulator-input-uV: Input voltage for regulator when supplied by another regulator
> +- regulator-always-on: boolean, regulator should never be disabled

We still need to figure out how to get the above board specific
data to the device driver probe in a way where we can avoid having
platform glue code. Any thoughts on that?

Tony
