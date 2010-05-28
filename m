Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab0E1Cvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:51:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57747 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab0E1Cva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:51:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/10] vmscan: Remove unnecessary temporary variables in shrink_zone()
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100526112143.GM29038@csn.ul.ie>
References: <20100416230332.GH20640@cmpxchg.org> <20100526112143.GM29038@csn.ul.ie>
Message-Id: <20100528114003.7E1B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 11:51:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Apr 17, 2010 at 01:03:32AM +0200, Johannes Weiner wrote:
> > On Fri, Apr 16, 2010 at 11:51:26AM +0900, KOSAKI Motohiro wrote:
> > > > Two variables are declared that are unnecessary in shrink_zone() as they
> > > > already exist int the scan_control. Remove them
> > > > 
> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > 
> > > ok.
> > > 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > You confuse me, you added the local variables yourself in 01dbe5c9
> > for performance reasons.  Doesn't that still hold?
> 
> To avoid a potential regression, I've dropped the patch.

I'm ok either.

Commit 01dbe5c9 issue was only observed on ia64. so it's not important.
But at making 01dbe5c9 time, I didn't realized this stack overflow issue.
So, I thought "Oh, It's no risk. should go!".

but if stack reducing is important, I'm ok to drop this one.


