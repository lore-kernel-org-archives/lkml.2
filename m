Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab2KFJsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:48:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40519 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2KFJsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:48:36 -0500
Message-ID: <5098DCD8.3090107@ti.com>
Date: Tue, 6 Nov 2012 15:18:08 +0530
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
Subject: Re: [PATCH v3 06/11] clk: davinci - add build infrastructure for
 DaVinci clock drivers
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-7-git-send-email-m-karicheri2@ti.com> <50966ED8.6070404@ti.com> <5097E6A1.2030804@ti.com>
In-Reply-To: <5097E6A1.2030804@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/5/2012 9:47 PM, Murali Karicheri wrote:
> On 11/04/2012 08:34 AM, Sekhar Nori wrote:
>> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>>> This updates clk Makefile and Kconfig to integrate the DaVinci specific
>>> clock drivers. Also add new Kconfig and Makefile for these drivers.
>>>
>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> As mentioned before, this should be folded into previous patches which
>> actually add the particular functionality.
> Yes. Agreed.,
>>> ---
>>>   drivers/clk/Kconfig          |    2 ++
>>>   drivers/clk/Makefile         |    1 +
>>>   drivers/clk/davinci/Kconfig  |   44
>>> ++++++++++++++++++++++++++++++++++++++++++
>>>   drivers/clk/davinci/Makefile |    5 +++++
>>>   4 files changed, 52 insertions(+)
>>>   create mode 100644 drivers/clk/davinci/Kconfig
>>>   create mode 100644 drivers/clk/davinci/Makefile
>>>
>>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>>> index 7f0b5ca..1ad2ab0 100644
>>> --- a/drivers/clk/Kconfig
>>> +++ b/drivers/clk/Kconfig
>>> @@ -33,6 +33,8 @@ config COMMON_CLK_DEBUG
>>>         clk_flags, clk_prepare_count, clk_enable_count &
>>>         clk_notifier_count.
>>>   +source "drivers/clk/davinci/Kconfig"
>>> +
>>>   config COMMON_CLK_WM831X
>>>       tristate "Clock driver for WM831x/2x PMICs"
>>>       depends on MFD_WM831X
>>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>>> index 5869ea3..b127b6f 100644
>>> --- a/drivers/clk/Makefile
>>> +++ b/drivers/clk/Makefile
>>> @@ -10,6 +10,7 @@ obj-$(CONFIG_ARCH_SOCFPGA)    += socfpga/
>>>   obj-$(CONFIG_PLAT_SPEAR)    += spear/
>>>   obj-$(CONFIG_ARCH_U300)        += clk-u300.o
>>>   obj-$(CONFIG_ARCH_INTEGRATOR)    += versatile/
>>> +obj-$(CONFIG_DAVINCI_CLKS)    += davinci/
>>>     # Chip specific
>>>   obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
>>> diff --git a/drivers/clk/davinci/Kconfig b/drivers/clk/davinci/Kconfig
>>> new file mode 100644
>>> index 0000000..e53bbc3
>>> --- /dev/null
>>> +++ b/drivers/clk/davinci/Kconfig
>>> @@ -0,0 +1,44 @@
>>> +menu "TI DaVinci Clock drivers"
>>> +    depends on COMMON_CLK
>>> +
>>> +config  CLK_DAVINCI_PSC
>>> +    bool "TI DaVici PSC clock driver"
>>> +    default n
>>> +    ---help---
>>> +      Selects clock driver for DaVinci PSC clocks. This clock
>>> +      hardware is found on TI DaVinci SoCs and other SoCs that
>>> +      uses this hardware IP. This hardware has a local power
>>> +      sleep control module that gate the clock to the IP.
>>> +
>>> +config  CLK_DAVINCI_PLL
>>> +    bool "DaVici main PLL clock"
>>> +    ---help---
>>> +      Selects clock driver for DaVinci main PLL. This clock
>>> +      hardware is found on TI DaVinci SoCs. This typically has
>>> +      a multiplier, a pre divider and post driver. Some of the
>>> +      SoCs has the the dividers fixed, and others have it
>>> +      programmable
>>> +
>>> +config  CLK_DAVINCI_PLLDIV
>>> +    bool "DaVici PLL divider clock"
>>> +    ---help---
>>> +      Selects clock driver for DaVinci PLL divider. This clock
>>> +      hardware is found on TI DaVinci SoCs. This typically has
>>> +      a divider and an enable bit to bypass or enable the
>>> +      divider.
>>> +
>>> +config DAVINCI_CLKS
>>> +    bool "TI DaVinci common clocks"
>>> +    default n
>>> +    select CLK_DAVINCI_PSC
>>> +    select CLK_DAVINCI_PLLDIV
>>> +    ---help---
>>> +      Selects common clock drivers for DaVinci. These clocks
>>> +      are re-used across many TI SoCs that are based on DaVinci and
>>> +      Keystone (c6x) families. This config option is used to select
>>> +      the common clock driver for DaVinci based SoCs. SoCs specific
>>> +      Kconfig option needs to select the driver for clocks specific
>>> +      to the SoC.
>>> +
>>> +endmenu
>> I wonder if all these configurations are really required. For complete
>> clock functionality you anyway require all this functionality so I
>> wonder why anyone would not select any of these. And to differentiate
>> between architecture changes, conditional build based on architecture
>> can be used:
> I know this is a grey area I need to improve and had a discussion with
> Mike sometime back. Are you also suggesting including davinci folder
> unconditionally under drivers/clk/Makefile? I think it will work. And
> then in clk/davinci/Makefile we can include on a per architecture basis.
> But I am not sure if calling the folder as davinci make sense and these
> drivers are used on non DaVinci architectures as well. I had initially
> named it as "ti" to include all ti drivers. But Mike had commented that
> current directory structure use platform/arch name instead of vendor
> name. Also OMAP is going to move the clk drivers to this folder soon. So
> for now, davinci may be used to house all of the non OMAP drivers. Later
> we can re-visit this as needed (wouldn't be that hard to do this within
> the clk driver folder later). We can keep the davinci folder name and
> unconditionally include it in clk/Makefile.
> 
> clk/Makefile
> 
> add
> obj-y      += davinci/

I am not sure about this unconditional inclusion. Are you sure the
following will create problems when DaVinci and keystone are enabled
together?

obj-$(CONFIG_ARCH_DAVINCI)	+= davinci/
obj-$(CONFIG_ARCH_KEYSTONE)	+= davinci/

> 
> clk/davinci/Makefile
> 
> obj-$(CONFIG_ARCH_DAVINCI) += clk-pll.o clk-div.o clk-psc.o clock.o
> obj-$(CONFIG_ARCH_KEYSTONE) +=   clk-pll-keystone.o clk-div.o clk-psc.o
> clock.o

Rather

obj-y				:= clk-div.o clk-psc.o clock.o
obj-$(CONFIG_ARCH_DAVINCI)	+= clk-pll.o
obj-$(CONFIG_ARCH_KEYSTONE)	+= clk-pll-keystone.o

Thanks,
Sekhar
