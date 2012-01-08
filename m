Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2AHQM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:12:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44463 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2AHQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:12:25 -0500
Date: Sun, 8 Jan 2012 16:12:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH v2 1/9] arm: avoid using on_each_cpu hard coded ret
	value
Message-ID: <20120108161212.GD21765@n2100.arm.linux.org.uk>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com> <1326029549-2794-2-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326029549-2794-2-git-send-email-gilad@benyossef.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 03:32:21PM +0200, Gilad Ben-Yossef wrote:
> on_each_cpu always returns a hard coded return code of zero.
> 
> Removing all tests based on this return value saves run time
> cycles for compares and code bloat for branches.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> CC: Russell King <linux@arm.linux.org.uk>

Reviewed-by: Russell King <rmk+kernel@arm.linux.org.uk>

> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: linux-arm-kernel@lists.infradead.org
> CC: devicetree-discuss@lists.ozlabs.org
> ---
>  arch/arm/kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 5bb91bf..6e9acb7 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -616,7 +616,7 @@ static int __init
>  cpu_pmu_reset(void)
>  {
>  	if (cpu_pmu && cpu_pmu->reset)
> -		return on_each_cpu(cpu_pmu->reset, NULL, 1);
> +		on_each_cpu(cpu_pmu->reset, NULL, 1);

There's not much to review here...

Thanks.

>  	return 0;
>  }
>  arch_initcall(cpu_pmu_reset);
> -- 
> 1.7.0.4
> 
