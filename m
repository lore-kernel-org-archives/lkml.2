Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2JXMB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:01:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:59731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab2JXMBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:01:55 -0400
Message-ID: <1351080078.13456.60.camel@twins>
Subject: Re: [PATCH 02/11] perf: Do not get values from disabled counters in
 group format read
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 24 Oct 2012 14:01:18 +0200
In-Reply-To: <20121023165040.GA7553@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
	 <1351008789.13456.37.camel@twins>
	 <20121023165040.GA7553@krava.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 18:50 +0200, Jiri Olsa wrote:
> On Tue, Oct 23, 2012 at 06:13:09PM +0200, Peter Zijlstra wrote:
> > On Sat, 2012-10-20 at 16:33 +0200, Jiri Olsa wrote:
> > > It's possible some of the counters in the group could be
> > > disabled when sampling member of the event group is reading
> > > the rest via PERF_SAMPLE_READ sample type processing. Disabled
> > > counters could then produce wrong numbers.
> > > 
> > > Fixing that by reading only enabled counters for PERF_SAMPLE_READ
> > > sample type processing.
> > > 
> > 
> > However did you run into this?
> 
> yep, with perf record -a
> 
> hm, I just checked and we enable/disable event groups atomicaly..
> I haven't checked that before because it seemed obvious :-/
> 
> So, I'm not sure now about the exact code path that triggered it
> in my test..  however you could always disable child event from
> group and hit this issue, but thats not what happened in perf.
> 
> might be some other bug... I'll check 

Right, so I don't object to the patch per-se, I was just curious how you
ran into it, because ISTR what you just said, we enable all this stuff
together.

Also, why would disabled counters give strange values? They'd simply
return the same old value time after time, right?
