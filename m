Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0H3NVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:21:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56557 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab0H3NVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:21:41 -0400
Date: Mon, 30 Aug 2010 14:21:38 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 2/5] perf: Turn the group counter values into
 delta values
Message-ID: <20100830132138.GA24828@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
 <1fe2a061e566c83668312ad64800768046f3ac07.1283123521.git.matt@console-pimps.org>
 <1283172841.1820.895.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283172841.1820.895.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 02:54:01PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-08-30 at 13:13 +0100, Matt Fleming wrote:
> > Change the semantics of the PERF_FORMAT_GROUP records and make them
> > delta values, i.e. the difference in value between consecutive reads of
> > the hardware counters. These delta values will be used in a subsequent
> > patch to calculate weighted values (by multiplying the deltas with the
> > time difference between reads of the counters). Calculating these deltas
> > is easiest to do in the kernel (as opposed to the userland tools)
> > because we can reset the counter whenever we read from it.
> > 
> > Note that even though this patch changes the semantics of
> > PERF_FORMAT_GROUP records there were no users of them anyway (the tools
> > didn't even understand them).
> 
> libpfmon might be using it,.. I know some people occasionally reported
> bugs for this so there are users.
> 
> Also, there's no real synchonization between read,read and read,sample
> so its racy to do this, simply generate deltas in post-processing.

Ah, fair enough. Thanks, I'll do this with post-processing.
