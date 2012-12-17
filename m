Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2LQQ2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:28:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2LQQ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:28:04 -0500
Message-ID: <50CF47FF.2010002@ti.com>
Date: Mon, 17 Dec 2012 17:27:43 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        <balbi@ti.com>, <sameo@linux.intel.com>, <keshava_mgowda@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: Re: [PATCH v4 16/23] ARM: OMAP2+: clock data: Merge utmi_px_gfclk
 into usb_host_hs_utmi_px_clk
References: <1355134833-5199-1-git-send-email-rogerq@ti.com> <1355134833-5199-17-git-send-email-rogerq@ti.com> <20121214182855.GB4989@atomide.com> <alpine.DEB.2.00.1212141838130.5915@utopia.booyaka.com> <50CED412.7060407@ti.com> <50CF449F.7090708@ti.com>
In-Reply-To: <50CF449F.7090708@ti.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:13 PM, Roger Quadros wrote:
> On 12/17/2012 10:13 AM, Benoit Cousson wrote:
>> Hi,
>>
>> On 12/14/2012 07:44 PM, Paul Walmsley wrote:
>>> Hi
>>>
>>> On Fri, 14 Dec 2012, Tony Lindgren wrote:
>>>
>>>> Paul, what about this patch? Looks like you've acked the other clock 
>>>> patches in this series but not this one?
>>>
>>> I commented on it briefly here:
>>>
>>> https://patchwork.kernel.org/patch/1838111/
>>>
>>> Maybe Benoît could comment here, but it looks to me (based on a 
>>> superficial look at the hardware clock tree data) that these clock nodes 
>>> should exist.  In an ideal world, we'd be able to get back to the 
>>> autogeneration of this clock data.
>>
>> I'm not sure to understand either the rational for that patch. What the
>> point of merging the two nodes?
>> I mean, we can do it, but AFAIR, we have always decided to use atomic
>> node instead of big nodes that handle everything.
>>
> 
> I can see a similar thing done for mcbsp clocks (e.g. /* Merged
> func_mcbsp1_gfclk into mcbsp1 */), mmc clocks, timer clocks, mcasp
> clock, and sgx clock. i.e. The clock sel (mux) is combined with clock
> gate. I don't see why USB host has to be done differently.

Hehe, well, in fact USB is using the right approach, the others are the
exceptions :-)

It was done for legacy reason but should disappear once the modulemode
will be be removed from the clock nodes.

> Were exceptions made for the above clocks in the auto generation code?
> 
> The problem from driver point of view is that it has to manage an
> additional clock per port. Not a big deal, but I thought it could be
> avoided.

In theory, the driver should just managed the mux. The modulemode being
managed already by hwmod.

Regards,
Benoit

