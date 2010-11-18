Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab0KRQep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:34:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:57705 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586Ab0KRQen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:34:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,217,1288594800"; 
   d="scan'208";a="628081219"
Date: Fri, 19 Nov 2010 00:34:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, "Li, Shaohua" <shaohua.li@intel.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: prevent bandwidth calculation overflow
Message-ID: <20101118163439.GA21318@localhost>
References: <20101118065725.GB8458@localhost>
 <4CE537BE.6090103@redhat.com>
 <20101118154408.GA18582@localhost>
 <1290096121.2109.1525.camel@laptop>
 <20101118160652.GA19459@localhost>
 <1290097740.2109.1527.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290097740.2109.1527.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:29:00AM +0800, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 00:06 +0800, Wu Fengguang wrote:
> > On Fri, Nov 19, 2010 at 12:02:01AM +0800, Peter Zijlstra wrote:
> > > On Thu, 2010-11-18 at 23:44 +0800, Wu Fengguang wrote:
> > > > +               pause = HZ * pages_dirtied / (bw + 1);
> > > 
> > > Shouldn't that be using something like div64_u64 ?
> > 
> > OK, but a dumb question: gcc cannot handle this implicitly?
> 
> it could, but we chose not to implement the symbol it emits for these
> things so as to cause pain.. that was still assuming the world of 32bit
> computing was relevant and 64bit divides were expensive ;-)

Good to know that, thanks!  So let's avoid it totally :)
