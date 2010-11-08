Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0KHKOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:14:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:35216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0KHKOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:14:23 -0500
Message-Id: <5b55a1$ijitko@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="624522904"
Date: Mon, 08 Nov 2010 10:14:19 +0000
To: Christoph Hellwig <hch@infradead.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20101108095610.GA22592@infradead.org>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com> <20101108095610.GA22592@infradead.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 04:56:10 -0500, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 08, 2010 at 02:05:12PM +0800, Yuanhan Liu wrote:
> > Trace event belongs to a module does exist only when the module is
> > loaded. Well, we can use trace_set_clr_event funtion to enable some
> > trace event at the module init routine, so that we will not miss
> > something while loading then module.
> > 
> > So, Export the trace_set_clr_event function so that module can use it.
> 
> Which module?

drm/i915. The scenario is that we want to enable a tracepoint to record
(selected) register writes both at runtime and module-load time. mmiotrace
is not quite sufficient for our needs, since we want to be enable
recording around a troublesome application from within X (i.e. without
having to ask the user to reload the module after enabling mmiotrace). We
also want to exclude the bit-banging registers from being traced since
they generate voluminous noise. So we settled on adding a tracepoint to
the our register read/write routines.

The question then became how to enable register tracing upon module load?
This was the simpler proposal, add a module parameter to enable the
tracepoints - hence the exporting of this routine. The alternative that we
are mulling over is whether it is possible for ftrace to parse a trace= on
every module load to manipulate the tracepoints within that module.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
