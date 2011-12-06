Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1LFPaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:30:55 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40547
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab1LFPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:30:54 -0500
Date: Tue, 6 Dec 2011 10:30:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] readahead: add vfs/readahead tracing event
Message-ID: <20111206153025.GA18974@infradead.org>
References: <20111129130900.628549879@intel.com>
 <20111129131456.797240894@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129131456.797240894@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	TP_printk("readahead-%s(dev=%d:%d, ino=%lu, "

please don't duplicate the tracepoint name in the output string.
Also don't use braces, as it jsut complicates parsing.

> +		  "req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d",
> +			ra_pattern_names[__entry->pattern],

Instead of doing a manual array lookup please use __print_symbolic so
that users of the binary interface (like trace-cmd) also get the
right output.

> --- linux-next.orig/mm/readahead.c	2011-11-29 20:58:53.000000000 +0800
> +++ linux-next/mm/readahead.c	2011-11-29 20:59:20.000000000 +0800
> @@ -29,6 +29,9 @@ static const char * const ra_pattern_nam
>  	[RA_PATTERN_ALL]                = "all",
>  };
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/vfs.h>

Maybe we should create a new fs/trace.c just for this instead of stickin
it into the first file that created a tracepoint in the "vfs" namespace.

