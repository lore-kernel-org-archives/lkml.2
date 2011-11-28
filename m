Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1K1Obx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:31:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47877 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1K1Obv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:31:51 -0500
Date: Mon, 28 Nov 2011 12:31:40 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        paulus@samba.org, mingo@elte.hu, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 7/7] event: add tracepoint for accounting block time
Message-ID: <20111128143140.GA12377@infradead.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <1322471015-107825-8-git-send-email-avagin@openvz.org>
 <1322480531.2921.107.camel@twins>
 <4ED39473.9080600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED39473.9080600@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 06:02:27AM -0800, Arjan van de Ven escreveu:
> On 11/28/2011 3:42 AM, Peter Zijlstra wrote:
> > On Mon, 2011-11-28 at 12:03 +0300, Andrew Vagin wrote:
> >> This tracepoint shows how long a task is sleeping in uninterruptible state.

> >> E.g.
> >> It may show how long and where a mutex is waited.

> > Fair enough, makes one wonder how much it would take to make
> > account_scheduler_latency() go away..

> I would *love* to switch latencytop to using trace points / perf events.
> But as long as this just means I get yelled at more for using "internal
> ABIs" and the like at various occasions, I'm rather hesitant to turn
> more tools into using perf.

Have you read the the discussion with Robert Richter about that?

https://lkml.org/lkml/2011/11/24/237

perf_evlist is what you call perf_bundle and perf_evsel is what you call
perf_event in powertop.

That part of the API should be ok for wider use and is in fact exported
in the python binding.

I'm rearranging my tmp.perf/trace4 branch into perf/core to ask for
merging, that is a step in the direction of having the 'perf tool' class
added to what will become libperf.so.

I almost embarked into an attempt to make powertop use it, but there are
other stuff to do first, like making the tracepoint based tools already
in perf stop using long if-strcmp(evname, "foo")-call-process_foo_event
(we have IDs, a hash, better use that, etc).

The 'strace' will be Ingo & tglx's 'trace' tool using these changes,
should be done in a way that shows how to use the resulting abstractions
in libperf.so, that together with the other tools already in the kernel
(kmem, lock, etc).

> (and we all know what the next steps to resolve this are, they just have
> not happened yet; not all hope is lost)

Sure its not :-)

- Arnaldo
