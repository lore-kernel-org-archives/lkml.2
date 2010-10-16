Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0JPGXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 02:23:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43467 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0JPGXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 02:23:22 -0400
Date: Sat, 16 Oct 2010 08:23:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/9] jump label: Fix module __init section race
Message-ID: <20101016062304.GA10748@elte.hu>
References: <20101015200949.134732894@goodmis.org>
 <20101015201036.445509790@goodmis.org>
 <1287194942.16971.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287194942.16971.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> 
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
> >  			count = e_module->nr_entries;
> >  			iter = e_module->table;
> >  			while (count--) {
> > -				if (kernel_text_address(iter->code))
> > +				if (iter->key &&
> > +						kernel_text_address(iter->code))
> 
> Peter, I know you hated this, but the alternative is either:
> 
> 				if (iter->key &&
> 				    kernel_text_address(iter->code))
> 
> or break 80 chars. All three seem bad (although I don't mind breaking 
> 80 chars for this). But I'll leave it for now.

No, the proper alternative is to move the body of the iteration into a 
jump_label_update_entry() inline function ...

Nobody is forcing you to start yet another iteration 4 indentations 
deep. We have functions for a reason.

Thanks,

	Ingo
