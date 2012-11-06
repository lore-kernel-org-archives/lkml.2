Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2KFXYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:24:21 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753864Ab2KFXYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:24:18 -0500
Date: Tue, 6 Nov 2012 17:24:15 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] procfs: /proc/sched_debug fails on very very large
	machines.
Message-ID: <20121106232414.GA7338@gulag1.americas.sgi.com>
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com> <1352235741-26478-2-git-send-email-nzimmer@sgi.com> <1352235741-26478-3-git-send-email-nzimmer@sgi.com> <20121106213128.GB1762@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106213128.GB1762@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:31:28PM -0500, Dave Jones wrote:
> On Tue, Nov 06, 2012 at 03:02:21PM -0600, Nathan Zimmer wrote:
>  > On systems with 4096 cores attemping to read /proc/sched_debug fails.
>  > We are trying to push all the data into a single kmalloc buffer.
>  > The issue is on these very large machines all the data will not fit in 4mb.
>  > 
>  > A better solution is to not us the single_open mechanism but to provide
>  > our own seq_operations and treat each cpu as an individual record.
> 
> Good timing.
> 
> This looks like it would solve the problem I just reported here:
> https://lkml.org/lkml/2012/11/6/390
> 
> That happens even on an 8-way, so it's not just niche machines that have
> this problems.
> 
> 	Dave
> 

Glad to help. I hadn't thought of memory tight situation but it does make sense
that it helps as it can get by with 4k allocation vs grabbing successively
large chucks.

If you have seen similar issues with your fuzz testing let me know where and
I'll take a look.

Nate

