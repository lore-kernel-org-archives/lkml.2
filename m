Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2ALPS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:18:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41720 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2ALPSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:18:25 -0500
Message-ID: <1326381492.2442.188.camel@twins>
Subject: Re: [PATCH 2/2] mm: page allocator: Do not drain per-cpu lists via
 IPI from page allocator context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
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
Date: Thu, 12 Jan 2012 16:18:12 +0100
In-Reply-To: <1326276668-19932-3-git-send-email-mgorman@suse.de>
References: <1326276668-19932-1-git-send-email-mgorman@suse.de>
	 <1326276668-19932-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 10:11 +0000, Mel Gorman wrote:
> At least one bug report has
> been seen on ppc64 against a 3.0 era kernel that looked like a bug
> receiving interrupts on a CPU being offlined. 

Got details on that Mel? The preempt_disable() in on_each_cpu() should
serialize against the stop_machine() crap in unplug.
