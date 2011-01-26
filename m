Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1AZThU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:37:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1AZThS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:37:18 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296070383.15234.10.camel@laptop>
References: <20110119182141.GA12183@redhat.com>
	 <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop>
	 <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop>
	 <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop>
	 <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com>
	 <20110126175322.GA28617@redhat.com>  <20110126184957.GA32578@redhat.com>
	 <1296068731.15234.6.camel@laptop>  <1296070383.15234.10.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 20:38:03 +0100
Message-ID: <1296070683.15234.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 20:33 +0100, Peter Zijlstra wrote:

> Wouldn't something like the below cure things too?

> +struct task_function_call {
> +	struct task_struct *p;
> +	void (*func)(void *info);
> +	void *info;
> +};
> +
> +void task_function_trampoline(void *data)
> +{
> +	struct task_function_call *tfc = data;
> +
> +	if (this_rq()->curr != tfc->p)
> +		return;
> +
> +	tfc->func(tfc->data);
> +}

tfc->info of course ;-)
