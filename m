Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2ATKFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 05:05:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44760 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2ATKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 05:05:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pmdOwA+G7qxphkELgU37v
Date: Fri, 20 Jan 2012 02:05:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120120100528.GJ22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwQoh4_SnA9wmy4x+cG0w0hGukxTkODWtcSw_2QHYuDsrg@mail.gmail.com>
 <20120119165607.GG22818@atomide.com>
 <CAJuYYwQB1pDu-JS5o3XPA1D8WbVcwbdtD43M4y7PeJNWeNXxQQ@mail.gmail.com>
 <20120119182019.GI22818@atomide.com>
 <CAJuYYwQouBDP6dL0B8QOaF0_JsbR7fysySZ5ebcF4op9aTQqbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwQouBDP6dL0B8QOaF0_JsbR7fysySZ5ebcF4op9aTQqbQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Abraham <thomas.abraham@linaro.org> [120119 10:05]:
> On 19 January 2012 23:50, Tony Lindgren <tony@atomide.com> wrote:
> 
> I would like to understand the need for populating the
> pinmux/pingroups tables from dt. The question here is when we have
> something like
> 
> pins = <&pinctrl0 0x0030 0x15 0x15 0x7>;
> 
> which specifies the values that need to be written to the hardware
> registers, would populating pinmux/pingroup tables from dt required.
> The SoC specific pinctrl driver can provide a way (with the help of
> pinctrl core) to translate these values and write to corresponding
> hardware registers. Is there any particular reason for populating the
> pinmux/pingroups tables from dt?

Hmm I see. Yes it's still needed as we only want to parse the DT once
because it's slower unless it was one time only configuration during
init.

If you only need to set pins once during the init, then we could add
an option for freeing all or most pins after init. That's what we
have for the current mach-omap2 mux framework as only few pins need
to be dynamically remuxed. That will require some changes to the
pinctrl framework though. We would need flags for each pin from DT
for init_only/dynamic.

Regards,

Tony
