Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0E1Cj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:39:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52045 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0E1Cj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:39:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/10] vmscan: move priority variable into scan_control
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100526102330.GL29038@csn.ul.ie>
References: <20100416224820.GE20640@cmpxchg.org> <20100526102330.GL29038@csn.ul.ie>
Message-Id: <20100528113404.7E18.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 11:39:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Sorry for the long delay on this. I got distracted by the anon_vma and
> page migration stuff.

Sorry for the delay too. I don't have enough development time recently ;)
I had tested this patch series a while. but now they need to rebase and retest. that's sad.

> On Sat, Apr 17, 2010 at 12:48:20AM +0200, Johannes Weiner wrote:
> > On Thu, Apr 15, 2010 at 06:21:35PM +0100, Mel Gorman wrote:
> > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > 
> > > Now very lots function in vmscan have `priority' argument. It consume
> > > stack slightly. To move it on struct scan_control reduce stack.
> > 
> > I don't like this much because it obfuscates value communication.
> > 
> > Functions no longer have obvious arguments and return values, as it's all
> > passed hidden in that struct.
> > 
> > Do you think it's worth it?  I would much rather see that thing die than
> > expand on it...
> 
> I don't feel strongly enough to fight about it and reducing stack usage here
> isn't the "fix" anyway. I'll drop this patch for now.

I'm ok either.


> That aside, the page reclaim algorithm maintains a lot of state and the
> "priority" is part of that state. While the struct means that functions might
> not have obvious arguments, passing the state around as arguments gets very
> unwieldly very quickly. I don't think killing scan_control would be as
> nice as you imagine although I do think it should be as small as
> possible.

I don't have strong opinion. I think both you and Hannes were talking correct thing.
But Hannes seems to have more strong opinion. then, I'm tend to drop this one.

Thanks.


