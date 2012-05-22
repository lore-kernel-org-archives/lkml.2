Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab2EVERT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:17:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19493 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2EVERS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:17:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6718"; a="191052199"
Message-ID: <4FBB134D.6050409@codeaurora.org>
Date: Mon, 21 May 2012 21:17:17 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Rob Herring <robherring2@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [GIT PULL] DT clk binding support
References: <4FB80F32.5090309@gmail.com> <20120520030653.GB5810@S2100-06.ap.freescale.net> <4FB9A5E7.2070000@gmail.com> <20120521064901.GE8140@S2101-09.ap.freescale.net> <4FBA89E3.7010106@gmail.com> <20120521232616.GF8140@S2101-09.ap.freescale.net> <4FBAD545.7060803@gmail.com> <20120522021535.GG8140@S2101-09.ap.freescale.net>
In-Reply-To: <20120522021535.GG8140@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/12 19:15, Shawn Guo wrote:
> On Mon, May 21, 2012 at 06:52:37PM -0500, Rob Herring wrote:
>> As Grant states: "This proposed binding is only about one thing:
>> attaching clock providers to clock consumers." This means you have to
>> have at least a single provider and a single consumer defined in the DT.
>>
> I just read through Grant's comments over again.  I agree with the
> statement which implicitly requires the clk provider defined in DT.
> However, for some case, this provider in DT is just a skeleton which
> is backed by clock driver where the provider is actually defined.
>
> Looking at Grant's comment below, the second option is also to match
> the clock in driver just using name.  The only difference to my
> proposal is the name here is given by the argument of phandle pointing
> to that skeleton provider node.
>
> I'm fine with that.  So go ahead with your bindings.
>

Can we do what the regulator framework has done and have a common
binding of <connection_name>-clk = <&phandle>? Something like:

    core-clk = <&uart3_clk>

and then have clk_get() use the of node of the device passed in to find
a property named %s-clk and find the clock with the matching phandle.

This looks like it's trying to cover both the end consumers (uart uses
uart3_clk) and the internal clock tree consumers (a crystal oscillator
connects to a PLL or a mux has multiple parents). We can certainly use
these bindings for muxes and internal parent-child relationships but I
would prefer we use different bindings for consumer bindings that match
what regulators do today.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

