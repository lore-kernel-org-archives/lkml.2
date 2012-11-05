Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2KETLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:11:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51533 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab2KETLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:11:35 -0500
Message-ID: <50980F57.1090507@ti.com>
Date: Mon, 5 Nov 2012 14:11:19 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 07/11] ARM: davinci - restructure header files for
 common clock migration
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-8-git-send-email-m-karicheri2@ti.com> <50967641.4090503@ti.com>
In-Reply-To: <50967641.4090503@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 09:05 AM, Sekhar Nori wrote:
>
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> pll.h is added to migrate some of the PLL controller defines for sleep.S.
>> psc.h is modified to keep only PSC modules definitions needed by sleep.S
>> after migrating to common clock. The definitions under
>> ifdef CONFIG_COMMON_CLK will be removed in a subsequent patch.
>> davinci_watchdog_reset prototype is moved to time.h as clock.h is
>> being obsoleted. sleep.S and pm.c is modified to include the new header
>> file replacements.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   arch/arm/mach-davinci/devices.c           |    2 ++
>>   arch/arm/mach-davinci/include/mach/pll.h  |   46 +++++++++++++++++++++++++++++
>>   arch/arm/mach-davinci/include/mach/psc.h  |    4 +++
>>   arch/arm/mach-davinci/include/mach/time.h |    4 ++-
>>   arch/arm/mach-davinci/pm.c                |    4 +++
>>   arch/arm/mach-davinci/sleep.S             |    4 +++
>>   6 files changed, 63 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm/mach-davinci/include/mach/pll.h
> With this patch a _third_ copy of PLL definitions is created in kernel
> sources. The existing PLL definitions in clock.h inside mach-davinci
> should be moved to mach/pll.h and the pll.h you introduced inside
> drivers/clk in 5/11 should be removed (this patch should appear before
> 5/11).
>
> The biggest disadvantage of this approach is inclusion of mach/ includes
> in drivers/clk. But duplicating code is definitely not the fix for this.
> Anyway, mach/ includes are not uncommon in drivers/clk (they are all
> probably suffering from the same issue).
Sekhar,

I have replied to patch 5/11 that also refers to this. The main reason 
we are not able to do this cleanly is the code in sleep.c and pm.c. That 
is something related to Power management. Could you take a look and see 
if you can do some clean up on this code? I believe It is more than just 
moving the header files.

Murali
>
> $ grep -rl "include <mach/" drivers/clk/*
> drivers/clk/clk-u300.c
> drivers/clk/mmp/clk-pxa168.c
> drivers/clk/mmp/clk-mmp2.c
> drivers/clk/mmp/clk-pxa910.c
> drivers/clk/mxs/clk-imx23.c
> drivers/clk/mxs/clk-imx28.c
> drivers/clk/spear/spear6xx_clock.c
> drivers/clk/spear/spear3xx_clock.c
> drivers/clk/spear/spear1340_clock.c
> drivers/clk/spear/spear1310_clock.c
> drivers/clk/ux500/clk-prcc.c
> drivers/clk/versatile/clk-integrator.c
> drivers/clk/versatile/clk-realview.c
>
> pll.h can probably be moved to include/linux/clk/ to avoid this. Would
> like to hear from Mike on this before going ahead.
>
> Anyway, instead of just commenting, I though I will be more useful and
> went ahead and made some of the changes I have been talking about. I
> fixed the multiple PLL definitions issue, the build infrastructure issue
> and the commit ordering too.
>
> I pushed the patches I fixed to devel-common-clk branch of my git tree.
> It is build tested using davinci_all_defconfig but its not runtime tested.
>
> Can you start from here and provide me incremental changes on top of
> this? That way we can collaborate to finish this faster.
Thanks for offering some help. Yes I can provide you incremental patch. 
But then could you also help me to squash/rebase and send patches to the 
list for review?
> Thanks,
> Sekhar
>

