Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0LMTWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:22:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59179 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0LMTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:22:48 -0500
Subject: Re: [tip:x86/tsc] x86: Check tsc available/disabled in the delayed
 init function
From: john stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a8760eca6cf60ed303ad494ef45901f63165d2c8@git.kernel.org>
References: <tip-a8760eca6cf60ed303ad494ef45901f63165d2c8@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 11:22:42 -0800
Message-ID: <1292268162.2673.29.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 10:37 +0000, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  a8760eca6cf60ed303ad494ef45901f63165d2c8
> Gitweb:     http://git.kernel.org/tip/a8760eca6cf60ed303ad494ef45901f63165d2c8
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 13 Dec 2010 11:28:02 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 13 Dec 2010 11:35:05 +0100
> 
> x86: Check tsc available/disabled in the delayed init function
> 
> The delayed TSC init function does not check whether the system has no
> TSC or TSC is disabled at the kernel command line, which results in a
> crash in the work queue based extended calibration due to division by
> zero because the basic calibration never happened.
> 
> Add the missing checks and do not touch TSC when not available or
> disabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <johnstul@us.ibm.com>

Thanks for catching this!

Acked-by: John Stultz <johnstul@us.ibm.com>


> ---
>  arch/x86/kernel/tsc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index dc1393e..356a0d4 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -965,6 +965,9 @@ out:
> 
>  static int __init init_tsc_clocksource(void)
>  {
> +	if (!cpu_has_tsc || tsc_disabled > 0)
> +		return 0;
> +
>  	if (tsc_clocksource_reliable)
>  		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
>  	/* lower the rating if we already know its unstable: */


