Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2KJCXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 21:23:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2KJCXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 21:23:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Murali Karicheri <m-karicheri2@ti.com>, Sekhar Nori <nsekhar@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5097D6FC.7040202@ti.com>
Cc: <arnd@arndb.de>, <akpm@linux-foundation.org>, <shawn.guo@linaro.org>,
        <rob.herring@calxeda.com>, <linus.walleij@linaro.org>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
 <1351181518-11882-3-git-send-email-m-karicheri2@ti.com>
 <50950908.1060302@ti.com> <5097D6FC.7040202@ti.com>
Message-ID: <20121110022254.18014.31873@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
Date: Fri, 09 Nov 2012 18:22:54 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Murali Karicheri (2012-11-05 07:10:52)
> On 11/03/2012 08:07 AM, Sekhar Nori wrote:
> > On 10/25/2012 9:41 PM, Murali Karicheri wrote:
> >> This is the driver for the Power Sleep Controller (PSC) hardware
> >> found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
> >> code from arch/arm/mach-davinci/psc.c and implemented the driver
> >> as per common clock provider API. The PSC module is responsible for
> >> enabling/disabling the Power Domain and Clock domain for different IPs
> >> present in the SoC. The driver is configured through the clock data
> >> passed to the driver through struct clk_psc_data.
> >>
> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> >> ---
> >> +/**
> >> + * struct clk_psc - DaVinci PSC clock driver data
> >> + *
> >> + * @hw: clk_hw for the psc
> >> + * @psc_data: Driver specific data
> >> + */
> >> +struct clk_psc {
> >> +    struct clk_hw hw;
> >> +    struct clk_psc_data *psc_data;
> >> +    spinlock_t *lock;
> > Unused member? I don't see this being used.
> 
> OK. Will remove.

Those locks are only used for the case where a register might contain
bits for several clocks.  Thus RMW operations are protected.  On OMAP
this isn't necessary due to a very generous register layout (typically
one 32-bit reg per module) controlling clocks.  Seems tha tmaybe this is
not needed for PSC module either?

Regards,
Mike

> >
> > Thanks,
> > Sekhar
> >
