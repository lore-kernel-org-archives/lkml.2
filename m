Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0ERVSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:18:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46426 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0ERVSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:18:42 -0400
Date: Tue, 18 May 2010 23:59:14 +0300
From: Imre Deak <imre.deak@nokia.com>
To: ext Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] idr: fix backtrack logic in idr_remove_all
Message-ID: <20100518205914.GA11667@localhost>
References: <319c869d40252c570a288166665635295d09108a.1273664539.git.imre.deak@nokia.com> <4BF26AD9.5070601@kernel.org> <20100518111823.GB5261@localhost> <4BF2B0E8.3060600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2B0E8.3060600@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 May 2010 20:59:20.0163 (UTC) FILETIME=[FC63A330:01CAF6CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 05:23:20PM +0200, ext Tejun Heo wrote:
> On 05/18/2010 01:18 PM, Imre Deak wrote:
> >> Shouldn't this be id ^ bt_mask?  The above only detects 1 -> 0
> >> transitions not the other way around.
> > 
> > It works according to the following with n=1:
> > 
> > id            id+2            fls((id+2) & ~id)
> > 0             2               2
> > 2             4               3
> > 4             6               2
> > 6             8               4
> > 8             10              2
> > 10            12              3
> > 12            14              2
> > 
> > I think this should work.
> 
> Ah, I thought you were doing fls(id & ~(id + 2)) and thus looking at 1
> -> 0 transitions.  It's the other way and you're looking for the
> highest 0 -> 1 transition which should be the same to the highest bit
> changing if you aren't overflowing.

Yes, both ways you get the same result and in case of overflow neither
will work.

> The patch looks good then.  I still think ^ test would be clearer tho.
> Hmmm...

Well xor results in one instruction less on machines without a nand
instruction, so I'll change that.

> Can you please add little comment there stating that you're
> looking for the highest bit flipping?

Yes, I'll re-test and follow up with an updated patch.

Thanks for the review,
Imre

> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> Thanks.
> 
