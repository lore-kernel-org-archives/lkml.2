Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2HQKV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:21:29 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33624 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab2HQKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:21:24 -0400
Message-ID: <502E1B1D.2030609@ti.com>
Date: Fri, 17 Aug 2012 15:51:17 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 28/31] arm64: Generic timers support
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> From: Marc Zyngier<marc.zyngier@arm.com>
>
> This patch adds support for the ARM generic timers with A64 instructions
> for accessing the timer registers. It uses the physical counter as the
> clock source and the virtual counter as sched_clock.
>
> The timer frequency can be specified via DT or read from the CNTFRQ_EL0
> register. The physical counter is also accessible from user space
> allowing fast gettimeofday() implementation.
>
> Signed-off-by: Marc Zyngier<marc.zyngier@arm.com>
> Signed-off-by: Will Deacon<will.deacon@arm.com>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> ---

[..]

> diff --git a/drivers/clocksource/arm_generic.c b/drivers/clocksource/arm_generic.c
> new file mode 100644
> index 0000000..05c898c
> --- /dev/null
> +++ b/drivers/clocksource/arm_generic.c

[..]

> +
> +static void __cpuinit arch_timer_setup(struct clock_event_device *clk)
> +{
> +	/* Let's make sure the timer is off before doing anything else */
> +	arch_timer_stop();
> +
> +	clk->features = CLOCK_EVT_FEAT_ONESHOT;
Are these CPU timers wakeup capable or we need the wakeup capable
broadcast timer for low power wakeups ?
In that case C3STOP would be needed here.

Regards
santosh
