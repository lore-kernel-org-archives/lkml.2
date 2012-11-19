Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2KSQCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:02:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46033 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2KSQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:02:01 -0500
Message-ID: <50AA57F3.6090707@gmail.com>
Date: Mon, 19 Nov 2012 17:01:55 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch> <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com> <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com> <20121117082602.GF24569@lunn.ch> <50A75BB4.4070003@free-electrons.com> <20121117135435.GA13479@lunn.ch> <20121119164611.2e754b64@skate>
In-Reply-To: <20121119164611.2e754b64@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 04:46 PM, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
>
> On Sat, 17 Nov 2012 14:54:35 +0100, Andrew Lunn wrote:
>>>> What is the ddr clock for? Does bad things happen if you turn it off?
>>>> Kirkwood has a similar clock, dunit, which i decided not to export,
>>>> since when you turn it off, the whole SoC locks up.
>>>
>>> Well of course if you code run in DDR then it could be a problem. But
>>> I think it could be useful to turn it off when going to suspend, it
>>> the DDR can do self-refresh. In this case it should be possible to run
>>> the code from SRAM or L2 Cache.
>>
>> O.K. Just watch out for the lateinit call in the clock framework.
>
> I don't think there is a problem with the dramclk and the lateinit call
> of the clock framework. The dramclk is a fixed factor clock, and the
> fixed factor clock driver does not implement the ->disable() operation.
> And therefore, the clk_disable_unused() code executed as the lateinit
> call will not be able to disable it:
>
> 	if (__clk_is_enabled(clk)&&  clk->ops->disable)
> 		clk->ops->disable(clk->hw);
>
> So I think we're quite safe with fixed rate clocks and fixed factor
> clocks in that no-one can disable them :-)

Thomas,

I guess Andrew was referring to the clock gating control bit for ddr on
Armada 370 not the fixed factor clock. If there is a clk_gate
installed, it will be disabled if not taken by any driver or init code.
You disable either the ddr controller clock or the external ddr clock
or both, but all will lead to a system lock up.

If unsure, you should remove bit 28 from clk-gating-ctrl.c and it's
devicetree documentation for Armada 370. Well get all the gates
straight as soon as we have more support for e.g. PMU, GEPHY, aso.

Sebastian
