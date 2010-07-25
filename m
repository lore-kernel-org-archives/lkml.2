Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0GYMD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 08:03:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63385 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0GYMDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 08:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DSfBvvpQ2t96tfM3uxr8N8A892c5Ho+gnLOrODNm9apII82HftxX3yaKvvksQj/PkE
         42z5hcsYeVRJw3PXZJT4w+NLUlWV9fHAXakXiiAL27Xsd/HC3t5xCl4xywG4ejIiN9pS
         a/5kjPd6AWA46cMzu2UShFs9dZqtV26oh1Fqw=
Date: Sun, 25 Jul 2010 21:03:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background
 writeback
Message-ID: <20100725120345.GA1817@barrios-desktop>
References: <20100723094515.GD5043@localhost>
 <20100723105719.GE5300@csn.ul.ie>
 <20100725192955.40D5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725192955.40D5.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 07:43:20PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> sorry for the delay.
> 
> > Will you be picking it up or should I? The changelog should be more or less
> > the same as yours and consider it
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > 
> > It'd be nice if the original tester is still knocking around and willing
> > to confirm the patch resolves his/her problem. I am running this patch on
> > my desktop at the moment and it does feel a little smoother but it might be
> > my imagination. I had trouble with odd stalls that I never pinned down and
> > was attributing to the machine being commonly heavily loaded but I haven't
> > noticed them today.
> > 
> > It also needs an Acked-by or Reviewed-by from Kosaki Motohiro as it alters
> > logic he introduced in commit [78dc583: vmscan: low order lumpy reclaim also
> > should use PAGEOUT_IO_SYNC]
> 
> My reviewing doesn't found any bug. however I think original thread have too many guess
> and we need to know reproduce way and confirm it.
> 
> At least, we need three confirms.
>  o original issue is still there?
>  o DEF_PRIORITY/3 is best value?

I agree. Wu, how do you determine DEF_PRIORITY/3 of LRU?
I guess system has 512M and 22M writeback pages. 
So you may determine it for skipping max 32M writeback pages.
Is right?

And I have a question of your below comment. 

"As the default dirty throttle ratio is 20%, sync write&wait
will hardly be triggered by pure dirty pages"

I am not sure exactly what you mean but at least DEF_PRIOIRTY/3 seems to be
related to dirty_ratio. It always can be changed by admin.
Then do we have to determine magic value(DEF_PRIORITY/3)  proportional to dirty_ratio?

-- 
Kind regards,
Minchan Kim
