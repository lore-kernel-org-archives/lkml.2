Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2DZSK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:10:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33616 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab2DZSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:10:25 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MLDgm-O3WeIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=u2j2EDpHsvSPNYeGFAoA:9 a=PUjeQqilurYA:10 a=DHQQ7jDAcw4A:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335463819.28106.187.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] timer: Fix mod_timer_pinned() header commen (was:
 [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ timers expire
 on correct CPU)
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 14:10:19 -0400
In-Reply-To: <20120426175608.GG2407@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
	 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335445496.13683.21.camel@twins>
	 <20120426155450.GD2407@linux.vnet.ibm.com>
	 <1335456539.28106.185.camel@gandalf.stny.rr.com>
	 <20120426175608.GG2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ------------------------------------------------------------------------
> 
> timer: Fix mod_timer_pinned() header comment
> 
> The mod_timer_pinned() header comment states that it prevents timers
> from being migrated to a different CPU.  This is not the case, instead,
> it ensures that the timer is posted to the current CPU, but does nothing
> to prevent CPU-hotplug operations from migrating the timer.
> 
> This commit therefore brings the comment header into alignment with
> reality.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I'm seeing double :-)

> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index a297ffc..7114336 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -861,7 +861,12 @@ EXPORT_SYMBOL(mod_timer);
>   *
>   * mod_timer_pinned() is a way to update the expire field of an
>   * active timer (if the timer is inactive it will be activated)
> - * and not allow the timer to be migrated to a different CPU.
> + * and to ensure that the timer is scheduled on the current CPU.

Add space here.

  + *

> + * Note that this does not prevent the timer from being migrated
> + * when the current CPU goes offline.  If this is a problem for
> + * you, use CPU-hotplug notifiers to handle it correctly, for
> + * example, cancelling the timer when the corresponding CPU goes
> + * offline.
>   *
>   * mod_timer_pinned(timer, expires) is equivalent to:
>   *

Adding a space will make the "Note" stand out more, and more likely seen
by people who use this function.

Other than that:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


