Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0DOGVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:21:02 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:49645 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339Ab0DOGVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:21:00 -0400
Date: Thu, 15 Apr 2010 16:20:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100415062055.GQ2493@dastard>
References: <20100414085132.GJ25756@csn.ul.ie>
 <20100415013436.GO2493@dastard>
 <20100415130212.D16E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415130212.D16E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 01:09:01PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > How about this? For now, we stop direct reclaim from doing writeback
> > only on order zero allocations, but allow it for higher order
> > allocations. That will prevent the majority of situations where
> > direct reclaim blows the stack and interferes with background
> > writeout, but won't cause lumpy reclaim to change behaviour.
> > This reduces the scope of impact and hence testing and validation
> > the needs to be done.
> 
> Tend to agree. but I would proposed slightly different algorithm for
> avoind incorrect oom.
> 
> for high order allocation
> 	allow to use lumpy reclaim and pageout() for both kswapd and direct reclaim

SO same as current.

> for low order allocation
> 	- kswapd:          always delegate io to flusher thread
> 	- direct reclaim:  delegate io to flusher thread only if vm pressure is low

IMO, this really doesn't fix either of the problems - the bad IO
patterns nor the stack usage. All it will take is a bit more memory
pressure to trigger stack and IO problems, and the user reporting the
problems is generating an awful lot of memory pressure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
