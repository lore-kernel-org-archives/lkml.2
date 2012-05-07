Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2EGP3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:29:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2EGP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:29:30 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBQQcENVAdZZ3PzEbwNNRFh+r9yax10s37cAe7uuOwBPOw@mail.gmail.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
	 <CABPqkBQQcENVAdZZ3PzEbwNNRFh+r9yax10s37cAe7uuOwBPOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 17:29:17 +0200
Message-ID: <1336404557.27020.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 17:21 +0200, Stephane Eranian wrote:
> There is something I don't quite understand with those pseudo-events.
> Is it the case that by construction, it means you can only measure
> on pseudo-event at a time? Supposed I want to look at cache-misses.
> For each miss, I'd like to know where it missed, any TLB impacts. All
> of that in one run with no multiplexing. Can I do this with your
> pseudo-events?
> 
Not from how I read the patch, a pseudo event will count as a full event
and since the IBS things only have a single thing its full.

If you want multiple of these you'd have to get the raw stream and demux
in userspace.



