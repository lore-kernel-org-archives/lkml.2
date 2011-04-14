Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1DNIOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:14:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45976 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab1DNIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YBFod4n2tYgqd/P10EQ7wzLReYnu1IoMTK0/WuWUgg9VbXy0ORCQjxUba6dpWTe952
         1EuxV9sG3IefZjvwnLJEqoqiMdgj5XdvXkA8bVa1y0k02PdCCFgQ7T/ipEQzx0t6Cnns
         zsnRcOO4U2h/0CWMQ+VOUP3bP6z+uM6gYZkZY=
Subject: Re: 2.6.38 sbrk regression
From: raz ben yehuda <raziebe@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20110413172127.GB5734@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
	 <20110413125146.GR29444@random.random>
	 <1302703579.17536.1.camel@raz.scalemp.com>
	 <20110413172127.GB5734@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 11:13:19 +0300
Message-ID: <1302768799.2706.15.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Hello

I performed the second benchmark on 2.6.39-rc3, not 38. I am sorry for
the typo ( dell keyboard is too small ).

1. First benchmark was performed on 2.6.38, no compaction and with
slab=y. regression of 13% compared to 2.6.27

2. second benchmark was performed on 2.6.39-rc3, with compaction and
slab. resulted like 2.6.38, 13% regression compared to 2.6.27. So the
2.6.39-rc1 fix is probably related to something else.

3. It does not matter if i disable thp or not.  regression still exits.

I will update you more in following few days. 

thank you for your help.



On Wed, 2011-04-13 at 19:21 +0200, Andrea Arcangeli wrote:
> On Wed, Apr 13, 2011 at 05:06:19PM +0300, raz ben yehuda wrote:
> > ok, managed to build 38-rc3 ( keep forgetting make mrproper ).
> > problem is still there:
> 
> Oops I thought it was typo on your prev email so I didn't answer
> assuming you would test 39-rc like I suggested in my prev email, I
> really meant 2.6.39-rc3.
> 
> The fix I refer to is d527caf22e48480b102c7c6ee5b9ba12170148f7 and
> it's included in >= 2.6.39-rc1. 38-rc3 has THP but not this
> changeset. We tried to push it for 38 final but it was a bit late so
> it got merged immediately in 39-rc1 to stay on the safe side (it's
> only a performance issue and the other longstanding irq/sched latency
> issues in compaction that got fixed in 39-rc1 where actually more
> relevant than the compaction-kswapd removal).


