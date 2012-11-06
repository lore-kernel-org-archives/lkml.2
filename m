Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2KFKTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:19:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42579 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2KFKTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:19:06 -0500
Message-ID: <5098E400.4000204@ti.com>
Date: Tue, 6 Nov 2012 15:48:40 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 05/11] clk: davinci - add dm644x clock initialization
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-6-git-send-email-m-karicheri2@ti.com> <50951C81.5050501@ti.com> <5097DE82.2090701@ti.com>
In-Reply-To: <5097DE82.2090701@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/2012 9:12 PM, Murali Karicheri wrote:
> On 11/03/2012 09:30 AM, Sekhar Nori wrote:
>> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>>> This patch adds dm644x clock initialization code that consists of
>>> clocks data for various clocks and clock register callouts to
>>> various clock drivers. It uses following clk drivers for this
>>>
>>>   1. clk-fixed-rate - for ref clock
>>>   2. clk-mux - for mux at the input and output of main pll
>>>   3. davinci specific clk-pll for main pll clock
>>>   4. davinci specific clk-div for pll divider clock
>>>   5. clk-fixed-factor for fixed factor clock such as auxclk
>>>   6. davinci specific clk-psc for psc clocks
>>>
>>> This patch also moves all of the PLL and PSC register definitions
>>> from clock.h and psc.h under davinci to the clk/davinci folder so
>>> that various soc specific clock initialization code can share these
>>> definitions.
>> Except this patch does not move the defines, it creates a copy of them
>> (which is bad since you quickly lose track of which is the correct
>> copy). Is this done to avoid including mach/ header files here?
> Yes.
>> It will
>> actually be better to include the mach/ files here as a temporary
>> solution and then remove the include mach/ files once all the SoCs have
>> been converted over.
> 
> I was thinking we are not allowed to include mach/* header files in
> driver files. But most of the clk drivers
> such clk-imx28, spear6xx_clock.c. versatile/clk-integrator.c etc are
> including mach/ headers. One issue is that the definitions in pll.h are
> re-usable across other machines falling under c6x and Keystone (new
> device we are working on) as well. Where do we keep includes that can be
> re-used across different architectures? include/linux/platform_data/ ?

In this case, it is not really platform data or even an interface for
drivers to use, so I prefer include/linux/clk/davinci-pll.h

> I
> see clk-integrator.h, clk-nomadik.h and clk-u300 sitting there. So I
> suggest moving any header files that defines utility functions, register
> definitions across different architectures to
> include/linux/platform_data. Candidate files would be clock.h, pll.h,
> clk-psc.h, clk-pll.h and clk-div.h. This way these can be used across

It is not clear to me why you would move these files outside of
drivers/clk/davinci. They are not used by any other code outside of this
directory.

> the above machines that use the above architectures. Can we do this in
> my next version? This way we don't have to make another move later. All
> these CLK IPs are re-used across multiple architectures and make perfect
> sense to me to move to the above folder.

Thanks,
Sekhar
