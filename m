Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2AZNz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:55:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2AZNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:55:28 -0500
Date: Thu, 26 Jan 2012 14:55:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120126135504.GA13107@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
 <20120117095418.GG10397@elte.hu>
 <1326807145.17534.26.camel@gandalf.stny.rr.com>
 <20120118120711.GB14863@elte.hu>
 <1326909412.17534.91.camel@gandalf.stny.rr.com>
 <877h0jgx80.fsf@rustcorp.com.au>
 <1327545664.22710.78.camel@gandalf.stny.rr.com>
 <20120126102836.GD3853@elte.hu>
 <1327585945.22710.87.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327585945.22710.87.camel@gandalf.stny.rr.com>
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

> On Thu, 2012-01-26 at 11:28 +0100, Ingo Molnar wrote:
> 
> > How much more do we save if we move all of try_module_get() out 
> > of line? It still seems a rather thick inline function with 
> > preempt section and all. I'd *really* suggest that it should all 
> > be uninlined.
> > 
> 
> Here's the #'s
> 
>    text	   data	    bss	    dec	    hex	filename
> 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
>    text	   data	    bss	    dec	    hex	filename
> 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
>    text	   data	    bss	    dec	    hex	filename
> 7477393	2248080	9719808	19445281	128b621	vmlinux-updatedpatch
> 
> Thus we get an additional 5k it seems, for a total of 13k savings.
> 
> The below patch is what I used. Note, since the tracepoint 
> requires the instruction pointer, I created stub versions that 
> call a "do_" version of the function to pass in the local 
> instruction counter.

Hm, why does this tracepoint include a flat RIP? It's pretty 
superfluous as there's various other (orghogonal) ways to get at 
the RIP.

If the field is needed for compatibility then lets set it to 
zero at the tracepoint level and not burden the module.h 
hotpath.

Thanks,

	Ingo
