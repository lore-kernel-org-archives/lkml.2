Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2K0PGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:06:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab2K0PGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:06:00 -0500
Message-ID: <50B4D6B1.3000903@ti.com>
Date: Tue, 27 Nov 2012 20:35:21 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <shawn.guo@linaro.org>,
        <rob.herring@calxeda.com>, <linus.walleij@linaro.org>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-3-git-send-email-m-karicheri2@ti.com> <50950908.1060302@ti.com> <5097D6FC.7040202@ti.com> <20121110022254.18014.31873@nucleus>
In-Reply-To: <20121110022254.18014.31873@nucleus>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 11/10/2012 7:52 AM, Mike Turquette wrote:
> Quoting Murali Karicheri (2012-11-05 07:10:52)
>> On 11/03/2012 08:07 AM, Sekhar Nori wrote:
>>> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>>>> This is the driver for the Power Sleep Controller (PSC) hardware
>>>> found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
>>>> code from arch/arm/mach-davinci/psc.c and implemented the driver
>>>> as per common clock provider API. The PSC module is responsible for
>>>> enabling/disabling the Power Domain and Clock domain for different IPs
>>>> present in the SoC. The driver is configured through the clock data
>>>> passed to the driver through struct clk_psc_data.
>>>>
>>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>>> ---
>>>> +/**
>>>> + * struct clk_psc - DaVinci PSC clock driver data
>>>> + *
>>>> + * @hw: clk_hw for the psc
>>>> + * @psc_data: Driver specific data
>>>> + */
>>>> +struct clk_psc {
>>>> +    struct clk_hw hw;
>>>> +    struct clk_psc_data *psc_data;
>>>> +    spinlock_t *lock;
>>> Unused member? I don't see this being used.
>>
>> OK. Will remove.
> 
> Those locks are only used for the case where a register might contain
> bits for several clocks.  Thus RMW operations are protected.  On OMAP
> this isn't necessary due to a very generous register layout (typically
> one 32-bit reg per module) controlling clocks.  Seems tha tmaybe this is
> not needed for PSC module either?

Sorry about the late reply. The above is not totally true for PSC. There
are some registers (like PTCMD) which are common for all clocks.

There is an enable_lock used in drivers/clk/clk.c which serializes all
enable/disable calls across the clock tree. Since that is done, further
locking at clk-psc level is not really needed, no?

Thanks,
Sekhar
