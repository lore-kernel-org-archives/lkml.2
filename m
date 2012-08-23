Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab2HWQHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2HWQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:07:32 -0400
Date: Thu, 23 Aug 2012 13:06:48 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120823160647.GA10777@t510.redhat.com>
References: <20120822093317.GC10680@redhat.com>
 <20120823021903.GA23660@x61.redhat.com>
 <20120823100107.GA17409@redhat.com>
 <20120823121338.GA3062@t510.redhat.com>
 <20120823123432.GA25659@redhat.com>
 <20120823130606.GB3746@t510.redhat.com>
 <20120823135328.GB25709@redhat.com>
 <20120823152128.GA8975@t510.redhat.com>
 <20120823155401.GA28876@redhat.com>
 <50365443.1070104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50365443.1070104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:03:15PM -0400, Rik van Riel wrote:
> >
> >Not "longer" - apparently forever unless user resend the leak command.
> >It's wrong - it should
> >1. not tell host if nothing was done
> >2. after migration finished leak and tell host
> 
> Agreed.  If the balloon is told to leak N pages, and could
> not do so because those pages were locked, the balloon driver
> needs to retry (maybe waiting on a page lock?) and not signal
> completion until after the job has been completed.
> 
> Having the balloon driver wait on the page lock should be
> fine, because compaction does not hold the page lock for
> long.

And that is precisely what leak_balloon is doing. When it stumbles across a
locked page it gets rid of that leak round to give a shot for compaction to
finish its task.


