Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0JPQXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:23:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0JPQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:23:22 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=oxfdMyKVvtIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ugVbe7CR-f__F_sOD2cA:9 a=Ww225aQhw8PxHZ6wtuYA:7 a=sAx0yup1IeeJ89cr4sbwLrkBvdcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=EdeJrhyXjyw6oHMG:21 a=oQiLyiSq-J0mkhEG:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/9] jump label: Fix module __init section race
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101016062304.GA10748@elte.hu>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.445509790@goodmis.org>
	 <1287194942.16971.39.camel@gandalf.stny.rr.com>
	 <20101016062304.GA10748@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Oct 2010 12:23:19 -0400
Message-ID: <1287246199.16971.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 08:23 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> > 
> > > --- a/kernel/jump_label.c
> > > +++ b/kernel/jump_label.c
> > > @@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
> > >  			count = e_module->nr_entries;
> > >  			iter = e_module->table;
> > >  			while (count--) {
> > > -				if (kernel_text_address(iter->code))
> > > +				if (iter->key &&
> > > +						kernel_text_address(iter->code))
> > 
> > Peter, I know you hated this, but the alternative is either:
> > 
> > 				if (iter->key &&
> > 				    kernel_text_address(iter->code))
> > 
> > or break 80 chars. All three seem bad (although I don't mind breaking 
> > 80 chars for this). But I'll leave it for now.
> 
> No, the proper alternative is to move the body of the iteration into a 
> jump_label_update_entry() inline function ...
> 
> Nobody is forcing you to start yet another iteration 4 indentations 
> deep. We have functions for a reason.

Jason,

Could you send me another version of this patch with the second
iteration wrapped in a function.

Thanks,

-- Steve


