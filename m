Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2AZSkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:40:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35809 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2AZSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:40:17 -0500
Date: Thu, 26 Jan 2012 19:39:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120126183946.GA14709@elte.hu>
References: <1326807145.17534.26.camel@gandalf.stny.rr.com>
 <20120118120711.GB14863@elte.hu>
 <1326909412.17534.91.camel@gandalf.stny.rr.com>
 <877h0jgx80.fsf@rustcorp.com.au>
 <1327545664.22710.78.camel@gandalf.stny.rr.com>
 <20120126102836.GD3853@elte.hu>
 <1327585945.22710.87.camel@gandalf.stny.rr.com>
 <20120126135504.GA13107@elte.hu>
 <1327586669.22710.89.camel@gandalf.stny.rr.com>
 <1327588606.22710.100.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327588606.22710.100.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2012-01-26 at 09:04 -0500, Steven Rostedt wrote:
> > [ Added Li who added the original tracepoint ]
> > 
> > On Thu, 2012-01-26 at 14:55 +0100, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > On Thu, 2012-01-26 at 11:28 +0100, Ingo Molnar wrote:
> > > > 
> > > > > How much more do we save if we move all of try_module_get() out 
> > > > > of line? It still seems a rather thick inline function with 
> > > > > preempt section and all. I'd *really* suggest that it should all 
> > > > > be uninlined.
> > > > > 
> > > > 
> > > > Here's the #'s
> > > > 
> > > >    text	   data	    bss	    dec	    hex	filename
> > > > 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
> > > >    text	   data	    bss	    dec	    hex	filename
> > > > 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
> > > >    text	   data	    bss	    dec	    hex	filename
> > > > 7477393	2248080	9719808	19445281	128b621	vmlinux-updatedpatch
> 
> 
> New numbers:
> 
>    text	   data	    bss	    dec	    hex	filename
> 7476509	2248048	9719808	19444365	128b28d	vmlinux-updatedpatch2
> 
> Just 916 bytes savings more. But gets rid of the hot path changes.
> 
> New patch below: (and the IP still works)

Ok, i like this one best. Rusty, does it look good to you too?

Thanks,

	Ingo
