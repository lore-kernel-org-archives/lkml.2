Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2JCNbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:31:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2JCNbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:31:21 -0400
Date: Wed, 3 Oct 2012 15:30:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCHv4] perf x86_64: Fix rsp register for system call fast path
Message-ID: <20121003133007.GD945@krava.brq.redhat.com>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
 <1349174644.7780.23.camel@twins>
 <20121002145815.GH6379@krava.brq.redhat.com>
 <20121002154914.GC10605@somewhere>
 <20121002160626.GA26598@krava.brq.redhat.com>
 <20121002161633.GF10605@somewhere>
 <20121003122947.GB945@krava.brq.redhat.com>
 <20121003123448.GA637@somewhere>
 <20121003131344.GC945@krava.brq.redhat.com>
 <1349270537.7780.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349270537.7780.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 03:22:17PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-10-03 at 15:13 +0200, Jiri Olsa wrote:
> > @@ -1190,8 +1191,8 @@ static inline void perf_sample_data_init(struct
> > perf_sample_data *data,
> >         data->raw  = NULL;
> >         data->br_stack = NULL;
> >         data->period = period;
> > -       data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
> > -       data->regs_user.regs = NULL;
> > +       /* Sets abi to PERF_SAMPLE_REGS_ABI_NONE. */
> > +       memset(&data->regs_user, 0, sizeof(data->regs_user));
> >         data->stack_user_size = 0;
> >  } 
> 
> Hmm, this will slow down all events, regardless of whether they use any
> of that stuff or not. Since the one user actually does something like:
> 
>   data->regs_user = *pt_regs;
> 
> except it does a memcpy() for some obscure reason, it really doesn't
> matter what is in there when uninitialized, right?

right, the init can stay as it was

jirka
