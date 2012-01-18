Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2AROaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:30:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50378 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab2AROa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:30:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120118141329.GA22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
	<20120116182808.GG4223@ponder.secretlab.ca>
	<20120118141329.GA22818@atomide.com>
Date: Wed, 18 Jan 2012 22:30:28 +0800
Message-ID: <CAAQ0ZWTtYz3Lg7=Xz29m07j_k8yA95hn6cyk92SAJ4iGJRT_gw@mail.gmail.com>
Subject: Re: Pinmux bindings proposal
From: Shawn Guo <shawn.guo@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 January 2012 22:13, Tony Lindgren <tony@atomide.com> wrote:
> Hi,
>
> * Grant Likely <grant.likely@secretlab.ca> [120116 09:55]:
>> On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
>> >                 pinmux =
>> >                         <"default" &pmx_sdhci_active>
>> >                         <"suspend" &pmx_sdhci_suspend>;
>> >
>> >                 /* 1:n example: */
>> >                 pinmux =
>> >                         <"default" &pmx_sdhci_mux_a>
>> >                         <"default" &pmx_sdhci_pincfg_a>
>> >                         <"suspend" &pmx_sdhci_mux_a>
>> >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
>>
>>
>> Yeah, don't do this.  Mixing phandle, string and cell values in a
>> property gets messy and could become troublesome to parse.  I've
>> backed away from it in the clk binding.
>
> Yup, that's because the string is embedded directly into the mixed
> mode array and will likely make the following data unaligned. That
> means it's extremely flakey to parse, and will lead into horrible
> errors if you have typos in the .dts file.. Tried that and gave up
> on it.
>
> I think I've found a way to avoid using names at all, assuming we set
> each pin as a phandle for the drivers to use :)
>
The problem with doing that is we will have to represent each pin as a
node in device tree.  For imx6q case, we have 197 pins.  Doing so will
bloat the device tree.

-- 
Regards,
Shawn
