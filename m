Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2EXJvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:51:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2EXJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:51:01 -0400
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-3-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:50:48 +0200
Message-ID: <1337853048.9783.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
>  /*
> + * Values for sample_regs when PERF_SAMPLE_REGS is set.
> + * Defines register set to be attached to the sample.
> + */
> +enum perf_sample_regs {
> +       PERF_SAMPLE_REGS_USER   = 1U << 0, /* user registers */
> +       PERF_SAMPLE_REGS_MAX    = 1U << 1, /* non-ABI */
> +};



> +       __u64   sample_regs; /* enum perf_sample_regs */
> +
> +       /*
> +        * Arch specific mask for PERF_SAMPLE_REGS_USER setup.
> +        * Defines set of user regs to dump on samples.
> +        * See asm/perf_regs.h for details.
> +        */
> +       __u64   sample_regs_user; 

This all just smells.. :/

So you're wasting 64 bits to specify PERF_SAMPLE_REGS_USER while also
implying we'll need another u64 for every other value of
perf_sample_regs?

What are we doing here and why?

