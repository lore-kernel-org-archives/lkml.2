Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2EXKo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:44:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2EXKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:44:27 -0400
Subject: Re: [PATCH 04/16] perf: Add ability to attach user stack dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-5-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 12:44:22 +0200
Message-ID: <1337856262.9783.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> @@ -173,6 +174,15 @@ enum perf_sample_regs {
>  };
>  
>  /*
> + * Values for sample_stack when PERF_SAMPLE_STACK is set.
> + * Defines stack dump to be attached to the sample.
> + */
> +enum perf_sample_stack {
> +       PERF_SAMPLE_STACK_USER  = 1U << 0, /* user stack */
> +       PERF_SAMPLE_STACK_MAX   = 1U << 1, /* non-ABI */
> +};
> +
> +/*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
>   *
> @@ -291,6 +301,14 @@ struct perf_event_attr {
>          * See asm/perf_regs.h for details.
>          */
>         __u64   sample_regs_user;
> +
> +       __u64   sample_stack; /* enum perf_sample_stack */
> +
> +       /*
> +        * Defines size of the user stack to dump on samples,
> +        * for sample_stack PERF_SAMPLE_STACK_USER settings.
> +        */
> +       __u64   sample_stack_user;
>  }; 

And here we have a similarly weird set-up. If you're ever going to add
another type, you have to make another __u64 since clearly another type
cannot use sample_stack_user per the name.

Thus, if you get another size variable you might as well use that to
discover the state that is now sample_stack.



