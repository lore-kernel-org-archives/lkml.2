Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031634Ab2COQLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:11:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:48412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab2COQLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:11:45 -0400
Message-ID: <1331827890.18960.198.camel@twins>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Date: Thu, 15 Mar 2012 17:11:30 +0100
In-Reply-To: <1331827843.18960.197.camel@twins>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	 <20120314161906.e53359d3.akpm@linux-foundation.org>
	 <20120315014511.GT27051@google.com> <1331809239.18960.168.camel@twins>
	 <1331809597.18960.171.camel@twins> <20120315124228.GA5318@elte.hu>
	 <1331820051.18960.187.camel@twins> <20120315143549.GC3941@redhat.com>
	 <20120315153907.GV27051@google.com> <1331827843.18960.197.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 17:10 +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-15 at 08:39 -0700, Mandeep Singh Baines wrote:
> > Its a good tool for catching problems of scale. As we move to more and
> > more cores you'll uncover bugs where data structures start to blow up.
> > Hash tables get huge, when you have 100000s of processes or millions
> > of
> > TCP flows, or cgroups or namespace. That critical section (spinlock,
> > spinlock_bh, or preempt_disable) that used to be OK might no longer
> > be.
> 
> Or you run with the preempt latency tracer.

Or for that matter run cyclictest...
