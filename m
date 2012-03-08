Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2CHPbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:31:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55011 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2CHPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:31:39 -0500
Date: Thu, 8 Mar 2012 16:31:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
Message-ID: <20120308153130.GC7976@somewhere.redhat.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
 <20120308072901.GC20784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308072901.GC20784@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 08:29:01AM +0100, Ingo Molnar wrote:
> 
> * Arun Sharma <asharma@fb.com> wrote:
> 
> > This patch series refactors existing code a bit and adds sort by 
> > inclusive time (time spent in the function + callees).
> > 
> > Sample command lines:
> > 
> > # perf record -ag -- sleep 1
> > # perf report -g graph,0.5,callee -n -s inclusive
> 
> So I tried this out with:
> 
>   $ taskset 1 perf record -g git gc
> 
> and got entries above 100% (in the TUI):
> 
>   $ perf report -g graph,0.5,callee -n -s inclusive
> 
>  +  321.11%        5628  [.] 0x392b609269
>  +  142.27%        3774  [.] create_delta
>  +  78.86%        1248  [.] lookup_object
>  +  40.54%        1348  [k] system_call_fastpath
>  [...]
> 
> Is that expected?

I think this happens because of this:

-               hists->stats.total_period += h->period;                                                                                
+               if (!h->inclusive)                                                                                                     
+                       hists->stats.total_period += h->period;

Which I'm not sure why it is needed btw.
