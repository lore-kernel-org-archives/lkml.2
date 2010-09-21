Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0IUTtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:49:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0IUTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:49:04 -0400
Date: Tue, 21 Sep 2010 21:48:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921194858.GB3024@one.firstfloor.org>
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com> <20100921131232.GA3024@one.firstfloor.org> <20100921143555.GA2873@redhat.com> <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org> <1285082049.23122.1930.camel@gandalf.stny.rr.com> <140ee1c060f22286fe2f4d81170f76be.squirrel@www.firstfloor.org> <1285092337.26872.12.camel@gandalf.stny.rr.com> <20100921182431.GA30075@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921182431.GA30075@Krystal>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with Steven, Peter and Jason: due to the large amount of
> tracepoints we can end up patching, we should keep the hash tables. This

I suspect when it's cache cold the hash tables will be actually slower.
As a general rule memory bloat = slow.

> code is very similar to what I have in the tracepoints already and in
> the immediate values. So this code is solid and has been tested over a
> large user base for quite some time already.

FWIW "We always did it this way" is not a good argument 
in engineering discussions.

> One change I would recommend is to use a separate memory pool to
> allocate the struct jump_label_entry, to favor better locality. I did
> not do it in tracepoints and markers because each entry have a variable
> length, but given that struct jump_label_entry seems to be fixed-size,
> then we should definitely go for a kmem_cache_alloc().

Yes even more complexity, great idea.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
