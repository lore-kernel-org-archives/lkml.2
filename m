Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1DLKzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:55:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60351 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1DLKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:55:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
Cc: kosaki.motohiro@jp.fujitsu.com, Andrey Vagin <avagin@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110411182606.016f9486.akpm@linux-foundation.org>
References: <20110412100417.43F2.A69D9226@jp.fujitsu.com> <20110411182606.016f9486.akpm@linux-foundation.org>
Message-Id: <20110412195513.B533.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 19:55:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > The above says "Eventually, oom-killer never works". Is this no enough?
> > The above says
> >   1) current logic have a race
> >   2) x86 increase a chance of the race by dma zone
> >   3) if race is happen, oom killer don't work
> 
> And the system hangs up, so it's a local DoS and I guess we should
> backport the fix into -stable.  I added this:
> 
> : This resulted in the kernel hanging up when executing a loop of the form
> : 
> : 1. fork
> : 2. mmap
> : 3. touch memory
> : 4. read memory
> : 5. munmmap
> : 
> : as described in
> : http://www.gossamer-threads.com/lists/linux/kernel/1348725#1348725
> 
> And the problems which the other patches in this series address are
> pretty deadly as well.  Should we backport everything?

patch [1/4] and [2/4] should be backported because they are regression fix.
But [3/4] and [4/4] are on borderline to me. they improve a recovery time 
from oom. some times it is very important, some times not. And it is not
regression fix. Our oom-killer is very weak from forkbomb attack since
very old days.

Thanks.


