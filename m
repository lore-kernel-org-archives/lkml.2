Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2AII22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:28:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38149 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2AII20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:28:26 -0500
Date: Mon, 9 Jan 2012 09:28:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        devicetree-discuss@lists.ozlabs.org, Will Deacon <will.deacon@arm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/9] arm: avoid using on_each_cpu hard coded ret value
Message-ID: <20120109082815.GB14252@pengutronix.de>
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
 <1325600353-10895-2-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325600353-10895-2-git-send-email-gilad@benyossef.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 04:19:05PM +0200, Gilad Ben-Yossef wrote:
> on_each_cpu always returns a hard coded return code of zero.
> 
> Removing all tests based on this return value saves run time
> cycles for compares and code bloat for branches.
> 
> Cc: Michal Nazarewicz <mina86@mina86.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: linux-arm-kernel@lists.infradead.org
> CC: devicetree-discuss@lists.ozlabs.org
> ---
>  arch/arm/kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 88b0941..bfd58d8 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -617,7 +617,7 @@ static int __init
>  cpu_pmu_reset(void)
>  {
>  	if (cpu_pmu && cpu_pmu->reset)
> -		return on_each_cpu(cpu_pmu->reset, NULL, 1);
> +		on_each_cpu(cpu_pmu->reset, NULL, 1);
>  	return 0;
>  }
>  arch_initcall(cpu_pmu_reset);
This patch results in no binary change for my test build with SMP=n and
it saves one instruction on SMP=y.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
