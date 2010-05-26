Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0EZKXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:23:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38754 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0EZKXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:23:50 -0400
Date: Wed, 26 May 2010 11:23:30 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 02/10] vmscan: move priority variable into scan_control
Message-ID: <20100526102330.GL29038@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-3-git-send-email-mel@csn.ul.ie> <20100416224820.GE20640@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100416224820.GE20640@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the long delay on this. I got distracted by the anon_vma and
page migration stuff.

On Sat, Apr 17, 2010 at 12:48:20AM +0200, Johannes Weiner wrote:
> On Thu, Apr 15, 2010 at 06:21:35PM +0100, Mel Gorman wrote:
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > Now very lots function in vmscan have `priority' argument. It consume
> > stack slightly. To move it on struct scan_control reduce stack.
> 
> I don't like this much because it obfuscates value communication.
> 
> Functions no longer have obvious arguments and return values, as it's all
> passed hidden in that struct.
> 
> Do you think it's worth it?  I would much rather see that thing die than
> expand on it...

I don't feel strongly enough to fight about it and reducing stack usage here
isn't the "fix" anyway. I'll drop this patch for now.

That aside, the page reclaim algorithm maintains a lot of state and the
"priority" is part of that state. While the struct means that functions might
not have obvious arguments, passing the state around as arguments gets very
unwieldly very quickly. I don't think killing scan_control would be as
nice as you imagine although I do think it should be as small as
possible.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
