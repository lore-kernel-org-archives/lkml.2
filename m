Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2ALPhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:37:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2ALPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:37:21 -0500
Date: Thu, 12 Jan 2012 15:37:12 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Miklos Szeredi <mszeredi@novell.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
        Gong Chen <gong.chen@intel.com>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
Message-ID: <20120112153712.GL4118@suse.de>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
 <1326276668-19932-3-git-send-email-mgorman@suse.de>
 <1326381492.2442.188.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1326381492.2442.188.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:18:12PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-01-11 at 10:11 +0000, Mel Gorman wrote:
> > At least one bug report has
> > been seen on ppc64 against a 3.0 era kernel that looked like a bug
> > receiving interrupts on a CPU being offlined. 
> 
> Got details on that Mel? The preempt_disable() in on_each_cpu() should
> serialize against the stop_machine() crap in unplug.

I might have added 2 and 2 together and got 5.

The stack trace clearly was while sending IPIs in on_each_cpu() and
always when under memory pressure and stuck in direct reclaim. This was
on !PREEMPT kernels where preempt_disable() is a no-op. That is why I
thought get_online_cpu() would be necessary.

-- 
Mel Gorman
SUSE Labs
