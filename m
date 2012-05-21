Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2EUJTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:19:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40660 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409Ab2EUJTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:19:40 -0400
Message-ID: <4FBA08A4.6030706@linaro.org>
Date: Mon, 21 May 2012 10:19:32 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au> <4FB9F818.4030801@linaro.org> <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au> <4FBA0460.1070300@linaro.org> <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
In-Reply-To: <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/12 10:10, Stephen Rothwell wrote:
> Hi Lee,
> 
> On Mon, 21 May 2012 10:01:20 +0100 Lee Jones<lee.jones@linaro.org>  wrote:
>>
>> That seems broken to me.
>>
>> Why would any of the X86_64 systems be building ab8500-core code?
> 
> Because the Kconfig allows it to ...

I think the issue may be on the x86 side. In -next I see:

> arch/arm/configs/u8500_defconfig:CONFIG_AB8500_CORE=y
> drivers/mfd/Kconfig:config AB8500_CORE

Expected

> drivers/gpio/Kconfig:           depends on AB8500_CORE && BROKEN
> drivers/input/misc/Kconfig:     depends on AB8500_CORE
> drivers/mfd/Kconfig:            depends on AB8500_CORE && MFD_DB8500_PRCMU
> drivers/mfd/Kconfig:            depends on AB8500_CORE && DEBUG_FS
> drivers/mfd/Kconfig:            depends on AB8500_CORE && REGULATOR_AB8500
> drivers/misc/Kconfig:           depends on AB8500_CORE && ARCH_U8500
> drivers/power/Kconfig:          depends on AB8500_CORE && AB8500_GPADC
> drivers/regulator/Kconfig:      depends on AB8500_CORE
> drivers/rtc/Kconfig:            depends on AB8500_CORE
> drivers/usb/otg/Kconfig:        depends on AB8500_CORE

I've just checked these, they are all AB8500 related Kconfig entries.

> include/linux/mfd/abx500/ab8500-sysctrl.h:#ifdef CONFIG_AB8500_CORE
> include/linux/mfd/abx500/ab8500-sysctrl.h:#endif /* CONFIG_AB8500_CORE */

> drivers/mfd/Makefile:obj-$(CONFIG_AB8500_CORE)  += ab8500-core.o ab8500-sysctrl.o

So somewhere along the line an X86 config is selecting CONFIG_AB8500_CORE when it shouldn't. 

I can't see anything relevant in my tree. I'll try to pull yours as have a look.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
