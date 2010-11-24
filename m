Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0KXNqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:46:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:24153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab0KXNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:46:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,248,1288594800"; 
   d="scan'208";a="680637993"
Date: Wed, 24 Nov 2010 21:46:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
Message-ID: <20101124134641.GA12987@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042850.002299964@intel.com>
 <1290596732.2072.450.camel@laptop>
 <20101124121046.GA8333@localhost>
 <1290603047.2072.465.camel@laptop>
 <20101124131437.GE10413@localhost>
 <20101124132012.GA12117@localhost>
 <1290606129.2072.467.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290606129.2072.467.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:42:09PM +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 21:20 +0800, Wu Fengguang wrote:
> > >         (jiffies - bdi->write_bandwidth_update_time < elapsed)
> > 
> > this will be true if someone else has _done_ overlapped estimation,
> > otherwise it will equal:
> > 
> >         jiffies - bdi->write_bandwidth_update_time == elapsed
> > 
> > Sorry the comment needs updating. 
> 
> Right, but its racy as hell..

Yeah, for N concurrent dirtiers, plus the background flusher, only
one is able to update write_bandwidth[_update_time]..

