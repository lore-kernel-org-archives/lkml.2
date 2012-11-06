Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2KFXt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab2KFXtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:49:55 -0500
Date: Tue, 6 Nov 2012 18:49:49 -0500
From: Dave Jones <davej@redhat.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] procfs: /proc/sched_debug fails on very very large
 machines.
Message-ID: <20121106234949.GA24258@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
 <1352235741-26478-2-git-send-email-nzimmer@sgi.com>
 <1352235741-26478-3-git-send-email-nzimmer@sgi.com>
 <20121106213128.GB1762@redhat.com>
 <20121106232414.GA7338@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106232414.GA7338@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 05:24:15PM -0600, Nathan Zimmer wrote:
 > On Tue, Nov 06, 2012 at 04:31:28PM -0500, Dave Jones wrote:
 > > On Tue, Nov 06, 2012 at 03:02:21PM -0600, Nathan Zimmer wrote:
 > >  > On systems with 4096 cores attemping to read /proc/sched_debug fails.
 > >  > We are trying to push all the data into a single kmalloc buffer.
 > >  > The issue is on these very large machines all the data will not fit in 4mb.
 > >  > 
 > >  > A better solution is to not us the single_open mechanism but to provide
 > >  > our own seq_operations and treat each cpu as an individual record.
 > > 
 > > Good timing.
 > > 
 > > This looks like it would solve the problem I just reported here:
 > > https://lkml.org/lkml/2012/11/6/390
 > > 
 > > That happens even on an 8-way, so it's not just niche machines that have
 > > this problems.
 > 
 > Glad to help. I hadn't thought of memory tight situation but it does make sense
 > that it helps as it can get by with 4k allocation vs grabbing successively
 > large chucks.
 > 
 > If you have seen similar issues with your fuzz testing let me know where and
 > I'll take a look.

I think /proc/timer_list could probably use the same treatment.
I had traces showing that using 64k allocations too, but I think I may have
just bricked my testbox.

	Dave

