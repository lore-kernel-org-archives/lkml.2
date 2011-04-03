Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1DCJcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:32:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49187 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1DCJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:32:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20110402011040.GG6957@dastard>
References: <20110401221921.A890.A69D9226@jp.fujitsu.com> <20110402011040.GG6957@dastard>
Message-Id: <20110403183229.AE4C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  3 Apr 2011 18:32:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 01, 2011 at 10:17:56PM +0900, KOSAKI Motohiro wrote:
> > > > But, I agree that now we have to concern slightly large VM change parhaps
> > > > (or parhaps not). Ok, it's good opportunity to fill out some thing.
> > > > Historically, Linux MM has "free memory are waste memory" policy, and It
> > > > worked completely fine. But now we have a few exceptions.
> > > >
> > > > 1) RT, embedded and finance systems. They really hope to avoid reclaim
> > > >    latency (ie avoid foreground reclaim completely) and they can accept
> > > >    to make slightly much free pages before memory shortage.
> > > 
> > > In general we need a mechanism to ensure we can avoid reclaim during
> > > critical sections of application. So some way to give some hints to the
> > > machine to free up lots of memory (/proc/sys/vm/dropcaches is far too
> > > drastic) may be useful.
> > 
> > Exactly.
> > I've heard multiple times this request from finance people. And I've also 
> > heared the same request from bullet train control software people recently.
> 
> Well, that's enough to make me avoid Japanese trains in future. 

Feel free do. :)

>If
> your critical control system has problems with memory reclaim
> interfering with it's operation, then you are doing something
> very, very wrong.
> 
> If you have a need to avoid memory allocation latency during
> specific critical sections then the critical section needs to:
> 
> 	a) have all it's memory preallocated and mlock()d in advance
> 
> 	b) avoid doing anything that requires memory to be
> 	   allocated.
> 
> These are basic design rules for time-sensitive applications.

I wonder why do you think our VM folks don't know that.


> Fundamentally, if you just switch off memory reclaim to avoid the
> latencies involved with direct memory reclaim, then all you'll get
> instead is ENOMEM because there's no memory available and none will be
> reclaimed. That's even more fatal for the system than doing reclaim.

You have two level oversight.

Firstly, *ALL* RT application need to cooperate applications, kernel, 
and other various system level daemons. That's no specific issue of 
this topic. OK, *IF* RT application run egoistic, a system may hang 
up easily even routh mere simple busy loop, yes. But, Who want to do so?

Secondly, You misparsed "avoid direct reclaim" paragraph. We don't talk
about "avoid direct reclaim even if system memory is no enough", We talk
about "avoid direct reclaim by preparing before". 


> IMO, you should tell the people requesting stuff like this to
> architect their critical sections according to best practices.
> Hacking the VM to try to work around badly designed applications is
> a sure recipe for disaster...

I hope this mail satisfy you. :)


