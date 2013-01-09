Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3AINqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:46:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab3AINqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:46:17 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S0zgfAou480A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=bnYEFHe5BS6znBRDnhoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357739175.5190.53.camel@gandalf.local.home>
Subject: Re: [PATCH 03/33] cputime: Generic on-demand virtual cputime
 accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 09 Jan 2013 08:46:15 -0500
In-Reply-To: <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	 <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index 5cc8713..51b5c33 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -322,6 +322,9 @@ source "kernel/time/Kconfig"
>  
>  menu "CPU/Task time and stats accounting"
>  
> +config VIRT_CPU_ACCOUNTING
> +	bool
> +
>  choice
>  	prompt "Cputime accounting"
>  	default TICK_CPU_ACCOUNTING if !PPC64
> @@ -338,9 +341,10 @@ config TICK_CPU_ACCOUNTING
>  
>  	  If unsure, say Y.
>  
> -config VIRT_CPU_ACCOUNTING
> +config VIRT_CPU_ACCOUNTING_NATIVE
>  	bool "Deterministic task and CPU time accounting"
>  	depends on HAVE_VIRT_CPU_ACCOUNTING
> +	select VIRT_CPU_ACCOUNTING
>  	help
>  	  Select this option to enable more accurate task and CPU time
>  	  accounting.  This is done by reading a CPU counter on each
> @@ -350,6 +354,15 @@ config VIRT_CPU_ACCOUNTING
>  	  this also enables accounting of stolen time on logically-partitioned
>  	  systems.
>  
> +config VIRT_CPU_ACCOUNTING_GEN
> +	bool "Full dynticks CPU time accounting"
> +	depends on HAVE_CONTEXT_TRACKING
> +	select VIRT_CPU_ACCOUNTING
> +	select CONTEXT_TRACKING

	select CONTEXT_TRACKING_FORCE

Otherwise the user time never gets updated.

-- Steve

> +	help
> +	  Implement a generic virtual based cputime accounting by using
> +	  the context tracking subsystem.
> +
>  config IRQ_TIME_ACCOUNTING
>  	bool "Fine granularity task level IRQ time accounting"
>  	depends on HAVE_IRQ_TIME_ACCOUNTING



