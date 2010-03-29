Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0C2RQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:16:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55034 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0C2RQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NVr15v98u4Z8CECvYskc4K+RfXnc+CmmcKWQzklzohBytXhnUKiWEWv+H2s5T5JCcA
         CdOmjYFM+5rooTKIqMa+qJwzVNdJfZZBLKt8tkxMTOht+Ec+rTTR8kFnPuVyGKhAi7ZF
         AhP72LD7kn5EYw+zKwN5MdLGIR1OvT5hpQSR8=
Date: Mon, 29 Mar 2010 19:16:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] perf: Correctly align perf event tracing buffer
Message-ID: <20100329171615.GA5101@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com> <1269753066-17246-2-git-send-regression-fweisbec@gmail.com> <1269852691.12097.162.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269852691.12097.162.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:51:31AM +0200, Peter Zijlstra wrote:
> On Sun, 2010-03-28 at 07:11 +0200, Frederic Weisbecker wrote:
> >  kernel/trace/trace_event_perf.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> > index 0709e4f..69941f3 100644
> > --- a/kernel/trace/trace_event_perf.c
> > +++ b/kernel/trace/trace_event_perf.c
> > @@ -15,7 +15,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
> >  static char *perf_trace_buf;
> >  static char *perf_trace_buf_nmi;
> >  
> > -typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
> > +/*
> > + * Force it to be aligned to unsigned long to avoid misaligned accesses
> > + * suprises
> > + */
> > +typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
> > +	perf_trace_t;
> >  
> 
> wouldn't __aligned(8) be simpler?


David and Tejun seemed to prefer to create the alignment on the
type level rather than using an align.

I'm personally fine either way.

