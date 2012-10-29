Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001Ab2J2VQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:16:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:14015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760764Ab2J2VQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:16:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="241642841"
Date: Mon, 29 Oct 2012 14:16:15 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20121029211615.GL2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
 <1351523752-4215-5-git-send-email-eranian@google.com>
 <20121029194203.GK2266@tassilo.jf.intel.com>
 <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why do you need to replace the whole table?
> >
> Because I am extending them with one or two events based on cpu
> model. That was the easiest way of doing this instead of playing
> some kind of malloc+copy trick.

I did malloc and copy.

> 
> > BTW I still think my approach in the v4 Haswell patchkit
> > is simpler and didn't rely on hardcoding these events.
> >
> I don't care about those events. As I found out, they are not even
> used by perf because they are all hardcoded and that's what gets
> used. I assume they are exposed for reference only. I don't object
> to that. But I think the right mechanism would be one where you
> can add events at boot time based on CPU model. It could be used
> to add the common events as well in the common part of the init
> code.

Yes that's what I did. 

I don't think copying everything for everything new is a good 
approach.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
