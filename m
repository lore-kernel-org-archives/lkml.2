Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2HUTU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:20:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10223 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HUTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:20:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6809"; a="227870086"
Message-ID: <5033DF72.70609@codeaurora.org>
Date: Tue, 21 Aug 2012 15:20:18 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 28/31] arm64: Generic timers support
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 01:52 PM, Catalin Marinas wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> This patch adds support for the ARM generic timers with A64 instructions
> for accessing the timer registers. It uses the physical counter as the
> clock source and the virtual counter as sched_clock.
> 
> The timer frequency can be specified via DT or read from the CNTFRQ_EL0
> register. The physical counter is also accessible from user space
> allowing fast gettimeofday() implementation.

[...]

> +++ b/drivers/clocksource/arm_generic.c

[...]

> +static void arch_timer_reg_write(int reg, u32 val)
> +{
> +	switch (reg) {
> +	case ARCH_TIMER_REG_CTRL:
> +		asm volatile("msr cntp_ctl_el0,  %0" : : "r" (val));
> +		break;
> +	case ARCH_TIMER_REG_TVAL:
> +		asm volatile("msr cntp_tval_el0, %0" : : "r" (val));
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	isb();
> +}

Doesn't architecture-specific assembly need to go in the arch directory rather
than the drivers directory?

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
