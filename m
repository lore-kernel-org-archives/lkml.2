Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0DOPpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:45:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51110 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0DOPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:45:04 -0400
Date: Thu, 15 Apr 2010 16:44:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
Message-ID: <20100415154442.GG10966@csn.ul.ie>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com> <20100415192140.D1A4.A69D9226@jp.fujitsu.com> <20100415131532.GD10966@csn.ul.ie> <87tyrc92un.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87tyrc92un.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 05:01:36PM +0200, Andi Kleen wrote:
> Mel Gorman <mel@csn.ul.ie> writes:
> >
> > $ stack-o-meter vmlinux-vanilla vmlinux-2-simplfy-shrink 
> > add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-144 (-144)
> > function                                     old     new   delta
> > shrink_zone                                 1232    1160     -72
> > kswapd                                       748     676     -72
> 
> And the next time someone adds a new feature to these code paths or
> the compiler inlines differently these 72 bytes are easily there
> again. It's not really a long term solution. Code is tending to get
> more complicated all the time. I consider it unlikely this trend will
> stop any time soon.
> 

The same logic applies when/if page writeback is split so that it is
handled by a separate thread.

> So just doing some stack micro optimizations doesn't really help 
> all that much.
> 

It's a buying-time venture, I'll agree but as both approaches are only
about reducing stack stack they wouldn't be long-term solutions by your
criteria. What do you suggest?


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
