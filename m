Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670Ab2J3TBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:01:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab2J3TBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:01:11 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UFStMaos_40A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Viq3Qss8UIsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=Ud_jFMACAAAA:8 a=OTiyzYomYmxXoefse40A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=SH6XC50OixQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351623668.4004.28.camel@gandalf.local.home>
Subject: Re: [PATCH 10/32] nohz/cpuset: Restart the tick if printk needs it
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Tue, 30 Oct 2012 15:01:08 -0400
In-Reply-To: <20121029203848.109112386@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203848.109112386@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0010-nohz-cpuset-Restart-the-tick-if-printk-needs-it.patch)
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> If we are in nohz adaptive mode and printk is called, the tick is
> missing to wake up the logger. We need to restart the tick when that
> happens. Do this asynchronously by issuing a tick restart self IPI
> to avoid deadlocking with the current random locking chain.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/printk.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 2d607f4..bf9048d 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -42,6 +42,7 @@
>  #include <linux/notifier.h>
>  #include <linux/rculist.h>
>  #include <linux/poll.h>
> +#include <linux/cpuset.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -1977,8 +1978,20 @@ int printk_needs_cpu(int cpu)
>  
>  void wake_up_klogd(void)
>  {
> -	if (waitqueue_active(&log_wait))
> +	unsigned long flags;
> +
> +	if (waitqueue_active(&log_wait)) {
>  		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
> +		/* Make it visible from any interrupt from now */
> +		barrier();
> +		/*
> +		 * It's safe to check that even if interrupts are not disabled.

Probably need to at least disable preemption. I don't see any
requirement that wake_up_klogd() needs to be called with preemption
disabled.

The this_cpu_or() doesn't care which CPU it triggers, but the enabling
of nohz does.

-- Steve

> +		 * If we enable nohz adaptive mode concurrently, we'll see the
> +		 * printk_pending value and thus keep a periodic tick behaviour.
> +		 */
> +		if (cpuset_adaptive_nohz())
> +			smp_cpuset_update_nohz(smp_processor_id());
> +	}
>  }
>  
>  static void console_cont_flush(char *text, size_t size)


