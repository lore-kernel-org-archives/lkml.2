Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2BCRcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:32:20 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56791 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2BCRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:32:19 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uAcPI9SoH05q0StlliHIi
Date: Fri, 3 Feb 2012 09:32:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120203173205.GB1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120201143530.GA2203@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
 <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dong Aisheng <dongas86@gmail.com> [120202 11:36]:
> 
> Actually i think i'd rather do not use config property, then i could
> be more compact:
> (anyway it's another issue and is flexible to be controlled by #pinmux-cells)
> pinctrl_usdhc4: pinconfig-usdhc4 {
>         /* 0: pin 1: group */
>         mux-entity = <0>;
>         func-name = "usdhc4func";
>         grp-name = "usdhc4grp";

The func-name and grp-name should be optional here.
This mux entry is already the group, and can be used as
the group name. And the function name can be generated
dynamically in most cases. I'm currently using np->full_name
of the driver claiming these pins as the function name.

>         mux =
>                 <MX6Q_SD4_CMD  0 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_CLK  0 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT0 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT1 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT2 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT3 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT4 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT5 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT6 1 MX6Q_USDHC_PAD_CTRL>
>                 <MX6Q_SD4_DAT7 1 MX6Q_USDHC_PAD_CTRL>;
> };

For listing basic pins this format works fine for me. It seems
to have low overhead for parsing. And the width of the array
can be driver specific.

Looks like it's the binding for altenative states that's still a
bit open..

So how about let's first standardize on the mux format above?

Then we can enhance it later for describing alternative states?
 
Regards,

Tony
