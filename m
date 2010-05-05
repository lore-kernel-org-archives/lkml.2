Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0EESaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:30:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab0EESaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sb6f8cdZHvGV50U9dwLXp84FxJM2uEVK4G+5I5awKcbuH2WVwn4n08mubvHL10Dawp
         406SjaV17rohU60ywQgtPtVQlXdjTyHTlwALccolqxjmW6B/XD1k839DQWPOTvmLLwVB
         QDdt0wvJM+y/lVzwLyxl3nimh1XK/BHX1fLZk=
Date: Wed, 5 May 2010 20:30:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
	perf on top of TP
Message-ID: <20100505183000.GF6320@nowhere>
References: <4BE0FB68.7080403@kernel.org> <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org> <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop> <1273083396.1642.251.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273083396.1642.251.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:16:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-05 at 20:15 +0200, Peter Zijlstra wrote:
> > 
> > Well, I'd much rather just see a direct call in the code than having to
> > reverse engineer wth hangs onto that _EVENT() junk.
> 
> And again, I oppose mandating CONFIG_TRACEEVENT.


And me too. But you don't need CONFIG_EVENT_TRACING for that.
TRACE_EVENT() with !CONFIG_EVENT_TRACING only produces tracepoints
if CONFIG_TRACEPOINTS.


In fact, a first progress that would handle these compromizes would
be to have CONFIG_PERF_EVENT_SW.

For now perf_event_task_sched_in and perf_event_task_sched_out can
stay as is because they are perf core utils.

But all the rest (faults, migrations, etc..) could be tracepoints builtin
only if CONFIG_PERF_EVENT_SW.
Which means CONFIG_PERF_EVENT_SW depends on CONFIG_TRACEPOINTS.

But nobody is forced to build CONFIG_PERF_EVENT_SW, breakpoints don't need
it.

