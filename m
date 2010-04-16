Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0DPOLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708Ab0DPOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:11:08 -0400
Subject: Re: vmalloc performance
From: Steven Whitehouse <swhiteho@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1271350270.2013.29.camel@barrios-desktop>
References: <1271089672.7196.63.camel@localhost.localdomain>
	 <1271249354.7196.66.camel@localhost.localdomain>
	 <m2g28c262361004140813j5d70a80fy1882d01436d136a6@mail.gmail.com>
	 <1271262948.2233.14.camel@barrios-desktop>
	 <1271320388.2537.30.camel@localhost>
	 <1271350270.2013.29.camel@barrios-desktop>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 16 Apr 2010 15:10:56 +0100
Message-Id: <1271427056.7196.163.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-04-16 at 01:51 +0900, Minchan Kim wrote:
[snip]
> Thanks for the explanation. It seems to be real issue. 
> 
> I tested to see effect with flush during rb tree search.
> 
> Before I applied your patch, the time is 50300661 us. 
> After your patch, 11569357 us. 
> After my debug patch, 6104875 us.
> 
> I tested it as changing threshold value.
> 
> threshold	time
> 1000		13892809
> 500		9062110
> 200		6714172
> 100		6104875
> 50		6758316
> 
My results show:

threshold        time
100000           139309948
1000             13555878
500              10069801
200              7813667
100              18523172
50               18546256

> And perf shows smp_call_function is very low percentage.
> 
> In my cases, 100 is best. 
> 
Looks like 200 for me.

I think you meant to use the non _minmax version of proc_dointvec too?
Although it doesn't make any difference for this basic test.

The original reporter also has 8 cpu cores I've discovered. In his case
divided by 4 cpus where as mine are divided by 2 cpus, but I think that
makes no real difference in this case.

I'll try and get some further test results ready shortly. Many thanks
for all your efforts in tracking this down,

Steve.


