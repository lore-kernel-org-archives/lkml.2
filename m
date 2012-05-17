Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab2EQMLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:11:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2EQMLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:11:49 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XlIr_nCh6zIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=n7lzCUN1pRk5MbKrU8gA:9 a=mKWEfrWPLEBYV7PoiZQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337256707.6724.101.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 17 May 2012 08:11:47 -0400
In-Reply-To: <20120517080651.GC17419@gmail.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
	 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
	 <1337198404.6724.81.camel@gandalf.stny.rr.com>
	 <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com>
	 <4FB408F2.8060002@linux.intel.com> <20120516201431.GA29661@redhat.com>
	 <4FB40B2B.703@linux.intel.com> <20120517080651.GC17419@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 10:06 +0200, Ingo Molnar wrote:

> Nor should we waste too much time over these 4 bytes really. Is 
> the kernel really in such a good shape that we must spend our 
> time trying to break working apps, over a mostly cosmetic detail 
> in an ABI which will soon be messed up with our next set up 
> mistakes anyway? ;-)
> 

4 bytes is not cosmetic for a 32 byte event. That's 1/8th overhead. If
we could get rid of 4 bytes from struct page, would we do that? It's
only just 4 bytes for ever 4096 bytes. Just a 1/1024 overhead. Of course
perf events are much bigger than 32 bytes. It's one of the biggest
complaints I hear about perf, the size of its events. We should be
trying hard to fix that.

And we are not spending time trying to break tools. The tools were
already broken. The main motivator for getting parse-events into
powertop was that the older version (due to this binary interface) could
not be used on a system running a 32bit userspace on a 64bit kernel.

With the proper parsing, it not only was able to run on a 32/64
environment, it can also parse the events like perf does and not need
direct padding of space.

-- Steve


