Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031353Ab2CPJtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:49:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:60671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192Ab2CPJtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:49:35 -0400
Message-ID: <1331891364.18960.221.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Fri, 16 Mar 2012 10:49:24 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 06:24 +0000, Liu, Chuansheng wrote:

> Based on your patch, I did a little modification, how do you think of that?

> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -640,8 +640,10 @@ void set_cpu_present(unsigned int cpu, bool present)
>  
>  void set_cpu_online(unsigned int cpu, bool online)
>  {
> -       if (online)
> +       if (online) {
>                 cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
> +               cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
> +       }
>         else
>                 cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
>  }

I'm thinking this lacks rationale. What was wrong, Why does this fix it.
If you can't answer that stop tinkering and start thinking.
