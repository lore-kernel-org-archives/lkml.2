Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1G1MNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:13:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:50320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1G1MNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:13:05 -0400
Subject: Re: [PATCH v2 5/6] trace: Add tracepoints to call function
 interrupt handlers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1311793038-15155-6-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-6-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 14:17:42 +0200
Message-ID: <1311855462.2617.171.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 11:57 -0700, Vaibhav Nagarnaik wrote:
> @@ -172,6 +173,7 @@ void generic_smp_call_function_interrupt(void)
>         struct call_function_data *data;
>         int cpu = smp_processor_id();
>  
> +       trace_call_function_ipi_entry(0);
>         /*
>          * Shouldn't receive this interrupt on a cpu that is not yet online.
>          */
> @@ -239,7 +241,7 @@ void generic_smp_call_function_interrupt(void)
>  
>                 csd_unlock(&data->csd);
>         }
> -
> +       trace_call_function_ipi_exit(0);
>  }
>  
>  /*
> @@ -252,6 +254,7 @@ void generic_smp_call_function_single_interrupt(void)
>         unsigned int data_flags;
>         LIST_HEAD(list);
>  
> +       trace_call_function_single_ipi_entry(0);
>         /*
>          * Shouldn't receive this interrupt on a cpu that is not yet online.
>          */
> @@ -282,6 +285,7 @@ void generic_smp_call_function_single_interrupt(void)
>                 if (data_flags & CSD_FLAG_LOCK)
>                         csd_unlock(data);
>         }
> +       trace_call_function_single_ipi_exit(0);
>  } 

The problem with this is that some archs only have a single IPI and
multiplex all IPIs on top, in that case you're either nesting interrupt
tracepoints or missing a part.

I really think you're doing this at the wrong level.

