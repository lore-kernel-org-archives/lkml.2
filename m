Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1HaBIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:08:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21358 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1HaBIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:08:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=w1ZCcsVGzDLfgcobH+86cKZCML2PRyDaPol3xvO71zt3USdm4qntFt8x6+OOaR5wR
	bpiDkeQHSep3UxtA+Xv6Q==
MIME-Version: 1.0
In-Reply-To: <1311210299-12607-1-git-send-email-vnagarnaik@google.com>
References: <1311210299-12607-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 30 Aug 2011 18:07:45 -0700
Message-ID: <CAL26m8KPDHPbad5y5ZYm4vY6i5TcgJ+tZSsT=r709dS9jX290Q@mail.gmail.com>
Subject: Re: [PATCH] trace: change CPU ring buffer state from tracing_cpumask
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 6:04 PM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> According to Documentation/trace/ftrace.txt:
>
> tracing_cpumask:
>
>        This is a mask that lets the user only trace
>        on specified CPUS. The format is a hex string
>        representing the CPUS.
>
> The tracing_cpumask currently doesn't affect the tracing state of
> per-CPU ring buffers.
>
> This patch enables/disables CPU recording as its corresponding bit in
> tracing_cpumask is set/unset.
>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  kernel/trace/trace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e8aa324..d8ed798 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2433,10 +2433,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
>                if (cpumask_test_cpu(cpu, tracing_cpumask) &&
>                                !cpumask_test_cpu(cpu, tracing_cpumask_new)) {
>                        atomic_inc(&global_trace.data[cpu]->disabled);
> +                       ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
>                }
>                if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
>                                cpumask_test_cpu(cpu, tracing_cpumask_new)) {
>                        atomic_dec(&global_trace.data[cpu]->disabled);
> +                       ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
>                }
>        }
>        arch_spin_unlock(&ftrace_max_lock);

Hi Steve

What do you think about this patch?

Vaibhav Nagarnaik
