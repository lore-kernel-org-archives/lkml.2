Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0KJQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:00:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab0KJQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vwWBL5eqRMHZkoKAMBIyihJdfaD7HlkeUPEa3oJJ2E91klrRRULcMMFUhplBEHcbvr
         UVbSv4q1buj0w2Pn4vnP5RMONBH5p+hY6WSFjRLL7iR+cb3LexZMizsjeNPN4EhpFK/a
         IHZ5z+D/7zx5ZQIeCFqEsSRvO1HnRrJuMrmj4=
Date: Wed, 10 Nov 2010 17:00:04 +0100
From: Dhaval Giani <dhaval@retis.sssup.it>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Luca Abeni <luca.abeni@unitn.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
Message-ID: <20101110160004.GA9092@gondor.retis>
References: <1288333128.8661.137.camel@Palantir>
 <1288333622.8661.141.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288333622.8661.141.camel@Palantir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Extended scheduling parameters data structure.
> + *
> + * This is needed because the original struct sched_param can not be
> + * altered without introducing ABI issues with legacy applications
> + * (e.g., in sched_getparam()).
> + *
> + * However, the possibility of specifying more than just a priority for
> + * the tasks may be useful for a wide variety of application fields, e.g.,
> + * multimedia, streaming, automation and control, and many others.
> + *
> + * This variant (sched_param_ex) is meant at describing a so-called
> + * sporadic time-constrained task. In such model a task is specified by:
> + *  - the activation period or minimum instance inter-arrival time;
> + *  - the maximum (or average, depending on the actual scheduling
> + *    discipline) computation time of all instances, a.k.a. runtime;
> + *  - the deadline (relative to the actual activation time) of each
> + *    instance.
> + * Very briefly, a periodic (sporadic) task asks for the execution of
> + * some specific computation --which is typically called an instance--
> + * (at most) every period. Moreover, each instance typically lasts no more
> + * than the runtime and must be completed by time instant t equal to
> + * the instance activation time + the deadline.
> + *
> + * This is reflected by the actual fields of the sched_param_ex structure:
> + *
> + *  @sched_priority     task's priority (might still be useful)
> + *  @sched_deadline     representative of the task's deadline
> + *  @sched_runtime      representative of the task's runtime
> + *  @sched_period       representative of the task's period
> + *  @sched_flags        for customizing the scheduler behaviour
> + *
> + * There are other fields, which may be useful for implementing (in
> + * user-space) advanced scheduling behaviours, e.g., feedback scheduling:
> + *
> + *  @curr_runtime       task's currently available runtime
> + *  @used_runtime       task's totally used runtime
> + *  @curr_deadline      task's current absolute deadline
> + *
> + * Given this task model, there are a multiplicity of scheduling algorithms
> + * and policies, that can be used to ensure all the tasks will make their
> + * timing constraints.
> + */
> +struct sched_param_ex {
> +	int sched_priority;
> +	struct timespec sched_runtime;
> +	struct timespec sched_deadline;
> +	struct timespec sched_period;
> +	unsigned int sched_flags;
> +
> +	struct timespec curr_runtime;
> +	struct timespec used_runtime;
> +	struct timespec curr_deadline;
> +};
> +

So, how extensible is this. What about when real time theory develops a
new algorithm which actually works practically, but needs additional
parameters? :-). (I am guessing that this interface should handle most
of the algorithms used these days). Any ideas?

Thanks,
Dhaval
