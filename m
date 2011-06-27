Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1F0LZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:25:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab1F0LXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:23:21 -0400
Subject: Re: [patch] perf_events: even more wrong events for AMD fam10h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Andre Przywara <andre.przywara@amd.com>
In-Reply-To: <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 13:22:21 +0200
Message-ID: <1309173741.6701.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 17:07 -0400, Vince Weaver wrote:
> Here are two more problems I found with the superlative "generalized" 
> events on AMD fam10h.
> 
> The "l1-dcache-loads" event measures loads *and* stores.
>     This might be as close as you can get on AMD, but it's still wrong
>       as it's not what Intel measures.  
>     My patch removes it.  Better might be to add a proper
>     "l1-dcache-access" event.

The question to ask is, does it still have a strong correlation?

> The "l1-dcache-load-miss" event is an invalid event. (0x141).
>     From what I can tell that event (DATA_CACHE_MISSES) does not
>     take a mask.  It should be 0x41.  And it's actually measuring
>     all misses, not just load misses, see above.

See commit 83112e688f5f05dea1e63787db9a6c16b2887a1d. Also same as above.

> The "l1-dcache-stores" event does not work.  See the
>      ./validation/l1-dcache-stores test found in 
>      http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html
>    So remove it until we figure out why.
> 

Robert?

> Also, is the value for "no such event" 0 or -1?  The perf_event_amd.c
> file seems to use them interchangably from what I can tell.

	val = hw_cache_event_ids[cache_type][cache_op][cache_result];

	if (val == 0)
		return -ENOENT;

	if (val == -1)
		return -EINVAL;


But yeah, somewhat inconsistent. Robert, Andre, could you guys go over
the AMD events some time?
