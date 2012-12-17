Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2LQQNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:13:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55364 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab2LQQNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:13:39 -0500
Message-ID: <50CF449F.7090708@ti.com>
Date: Mon, 17 Dec 2012 18:13:19 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        <balbi@ti.com>, <sameo@linux.intel.com>, <keshava_mgowda@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: Re: [PATCH v4 16/23] ARM: OMAP2+: clock data: Merge utmi_px_gfclk
 into usb_host_hs_utmi_px_clk
References: <1355134833-5199-1-git-send-email-rogerq@ti.com> <1355134833-5199-17-git-send-email-rogerq@ti.com> <20121214182855.GB4989@atomide.com> <alpine.DEB.2.00.1212141838130.5915@utopia.booyaka.com> <50CED412.7060407@ti.com>
In-Reply-To: <50CED412.7060407@ti.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 10:13 AM, Benoit Cousson wrote:
> Hi,
> 
> On 12/14/2012 07:44 PM, Paul Walmsley wrote:
>> Hi
>>
>> On Fri, 14 Dec 2012, Tony Lindgren wrote:
>>
>>> Paul, what about this patch? Looks like you've acked the other clock 
>>> patches in this series but not this one?
>>
>> I commented on it briefly here:
>>
>> https://patchwork.kernel.org/patch/1838111/
>>
>> Maybe Benoît could comment here, but it looks to me (based on a 
>> superficial look at the hardware clock tree data) that these clock nodes 
>> should exist.  In an ideal world, we'd be able to get back to the 
>> autogeneration of this clock data.
> 
> I'm not sure to understand either the rational for that patch. What the
> point of merging the two nodes?
> I mean, we can do it, but AFAIR, we have always decided to use atomic
> node instead of big nodes that handle everything.
>

I can see a similar thing done for mcbsp clocks (e.g. /* Merged
func_mcbsp1_gfclk into mcbsp1 */), mmc clocks, timer clocks, mcasp
clock, and sgx clock. i.e. The clock sel (mux) is combined with clock
gate. I don't see why USB host has to be done differently.

Were exceptions made for the above clocks in the auto generation code?

The problem from driver point of view is that it has to manage an
additional clock per port. Not a big deal, but I thought it could be
avoided.

regards,
-roger


