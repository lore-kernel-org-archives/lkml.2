Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1JDAXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:23:03 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14439 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1JDAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:23:00 -0400
Message-ID: <4E8A51AC.8060905@cavium.com>
Date: Mon, 03 Oct 2011 17:22:04 -0700
From: Venkat Subbiah <venkat.subbiah@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
CC: linux-rt-users@vger.kernel.org, david.daney@cavium.com
Subject: Re: [PATCH] MIPS: Octeon: Mark octeon_wdt interrupt as IRQF_NO_THREAD
References: <1317684628-17488-1-git-send-email-venkat.subbiah@cavium.com>
In-Reply-To: <1317684628-17488-1-git-send-email-venkat.subbiah@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2011 00:22:59.0284 (UTC) FILETIME=[C555C940:01CC822B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 04:30 PM, Venkat Subbiah wrote:
> This is to exclude it from force threading to allow RT patch set to work.
>
> The watchdog timers are per-CPU and the addresses of register that reset
> the timer are calculated based on the current CPU.  Therefore we cannot
> allow it to run on a thread on a different CPU.  Also we only do a
> single register write, which is much faster than scheduling a handler
> thread.
>
> And while on this line remove IRQF_DISABLED as this flag is a NOP.
>
>
> Signed-off-by: Venkat Subbiah<venkat.subbiah@cavium.com>
> Acked-by: David Daney<david.daney@cavium.com>
> ---
>   drivers/watchdog/octeon-wdt-main.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
> index 945ee83..7c0d863 100644
> --- a/drivers/watchdog/octeon-wdt-main.c
> +++ b/drivers/watchdog/octeon-wdt-main.c
> @@ -402,7 +402,7 @@ static void octeon_wdt_setup_interrupt(int cpu)
>   	irq = OCTEON_IRQ_WDOG0 + core;
>
>   	if (request_irq(irq, octeon_wdt_poke_irq,
> -			IRQF_DISABLED, "octeon_wdt", octeon_wdt_poke_irq))
> +			IRQF_NO_THREAD, "octeon_wdt", octeon_wdt_poke_irq))
>   		panic("octeon_wdt: Couldn't obtain irq %d", irq);
>
>   	cpumask_set_cpu(cpu,&irq_enabled_cpus);
Sending it to kernel watchdog maintainers. Forgot to include them in the prior email.

Thanks,
Venkat

