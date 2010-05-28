Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0E1PIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:08:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:50757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab0E1PIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:08:48 -0400
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve
 documentation
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100528134233.GA28190@sig21.net>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100526160252.325f8357.akpm@linux-foundation.org>
	 <1274942798.27810.3584.camel@twins>
	 <20100526235107.77e66ce0.akpm@linux-foundation.org>
	 <1274945751.27810.3765.camel@twins>
	 <20100527113340.d4afb8fc.akpm@linux-foundation.org>
	 <1275052414.1645.52.camel@laptop>  <20100528134233.GA28190@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 17:08:32 +0200
Message-ID: <1275059312.27810.9600.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 15:42 +0200, Johannes Stezenbach wrote:
> On Fri, May 28, 2010 at 03:13:34PM +0200, Peter Zijlstra wrote:
> > + * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
> 
> typo                ^
> 
> Thank you for adding documentation.  I have one additional
> question regarding wrapping of sched_clock().  I know it is
> used for timestamps in ftrace and printk, so it's desirable
> that it never wraps.  But on several embedded systems
> it wraps after a few hours.  Bug or just a minor flaw?
> If someone knows it would be nice to get that documented, too.

The scheduler assumes it wraps at u64, however since we mostly use it to
compute a time deltas it mostly works, even when it wraps sooner, its
just that we get large jumps once in a while when it does wraps, due to
(s64)(new - old) not ending up being a proper s64.

If you have CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, these jumps will be
filtered out and polished over.
