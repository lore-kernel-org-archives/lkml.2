Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0KJSur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:50:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39258 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KJSuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:50:46 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333622.8661.141.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 19:50:17 +0100
Message-ID: <1289415017.2084.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
>  static int __sched_setscheduler(struct task_struct *p, int policy,
> -                               const struct sched_param *param, bool user)
> +                               const struct sched_param *param,
> +                               const struct sched_param_ex *param_ex,
> +                               bool user)
>  {
>         int retval, oldprio, oldpolicy = -1, on_rq, running;
>         unsigned long flags;
> @@ -4861,10 +4863,18 @@ recheck:
>  int sched_setscheduler(struct task_struct *p, int policy,
>                        const struct sched_param *param)
>  {
> -       return __sched_setscheduler(p, policy, param, true);
> +       return __sched_setscheduler(p, policy, param, NULL, true);
>  }
>  EXPORT_SYMBOL_GPL(sched_setscheduler);
>  
> +int sched_setscheduler_ex(struct task_struct *p, int policy,
> +                         const struct sched_param *param,
> +                         const struct sched_param_ex *param_ex)
> +{
> +       return __sched_setscheduler(p, policy, param, param_ex, true);
> +}
> +EXPORT_SYMBOL_GPL(sched_setscheduler_ex); 

Do we really need to pass both params? Can't we simply create a struct
sched_param_ex new_param = { .sched_priority = param->sched_priority };
on stack and pass that?


