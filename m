Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2JEKal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:30:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35537 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab2JEKaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:30:39 -0400
Message-ID: <506EB6B7.4050705@ti.com>
Date: Fri, 5 Oct 2012 16:00:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] ARM: davinci: Add support for PRUSS on DA850
References: <1349276133-26408-1-git-send-email-mporter@ti.com> <1349276133-26408-6-git-send-email-mporter@ti.com> <506D7F95.2030401@ti.com> <20121004163546.GK11149@beef>
In-Reply-To: <20121004163546.GK11149@beef>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2012 10:05 PM, Matt Porter wrote:
> On Thu, Oct 04, 2012 at 05:52:45PM +0530, Sekhar Nori wrote:
>> On 10/3/2012 8:25 PM, Matt Porter wrote:
>>> +static struct clk pruss_clk = {
>>> +	.name		= "pruss",
>>> +	.parent		= &pll0_sysclk2,
>>> +	.lpsc		= DA8XX_LPSC0_PRUSS,
>>> +};
>>> +
>>>  static struct clk uart0_clk = {
>>>  	.name		= "uart0",
>>>  	.parent		= &pll0_sysclk2,
>>> @@ -378,6 +384,7 @@ static struct clk_lookup da850_clks[] = {
>>>  	CLK(NULL,		"tptc1",	&tptc1_clk),
>>>  	CLK(NULL,		"tpcc1",	&tpcc1_clk),
>>>  	CLK(NULL,		"tptc2",	&tptc2_clk),
>>> +	CLK(NULL,		"pruss",	&pruss_clk),
>>
>> This is actually incorrect since we should use device name rather than
>> con_id for matching the clock. If there is just one clock that the
>> driver needs, connection id should be NULL. Looking at the driver now,
>> the clk_get() call seems to pass a valid device pointer. So, I wonder
>> how you are able to look up the clock even with a NULL device name.
> 
> I doublechecked the clk_get() find implentation to confirm that I indeed
> did get lucky here. Since pruss has only one instance and the clk_find()
> implementation looks for the best found match, it's able to find the
> clock just by the con_id, though it's not the "best possible" match in
> the find implementation...it's the "best found" match.. As you noted,
> this is incorrect though for a clock expected to be used from a driver
> context so I will address this in the update.

Thanks for debugging and clarifying.

Regards,
Sekhar
