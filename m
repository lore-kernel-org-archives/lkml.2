Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0HQExi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:53:38 -0400
Received: from ozlabs.org ([203.10.76.45]:57988 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0HQExh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:53:37 -0400
Date: Tue, 17 Aug 2010 14:53:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 5/6 v4] perf: Fix race in callchains
Message-ID: <20100817045331.GE24726@drongo>
References: <1281991715-10367-6-git-send-regression-fweisbec@gmail.com>
 <1282008846-11833-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282008846-11833-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 03:34:06AM +0200, Frederic Weisbecker wrote:

> Now that software events don't have interrupt disabled anymore in
> the event path, callchains can nest on any context. So seperating
> nmi and others contexts in two buffers has become racy.
> 
> Fix this by providing one buffer per nesting level. Given the size
> of the callchain entries (2040 bytes * 4), we now need to allocate
> them dynamically.
> 
> v2: Fixed put_callchain_entry call after recursion.
>     Fix the type of the recursion, it must be an array.
> 
> v3: Use a manual pr cpu allocation (temporary solution until NMIs
>     can safely access vmalloc'ed memory).

It would be nice to make these allocations node-local.

Also, I see that we're allocating 4 buffers per cpu on powerpc when we
strictly only need 3, but I don't suppose that really matters.

Paul.
