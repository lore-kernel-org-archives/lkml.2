Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab2FLJ4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:56:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:38139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2FLJ4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:56:19 -0400
Message-ID: <1339494970.31548.66.camel@twins>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Charles Wang <muming.wq@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Charles Wang <muming.wq@taobao.com>, Tao Ma <tm@tao.ma>,
        =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>
Date: Tue, 12 Jun 2012 11:56:10 +0200
In-Reply-To: <4FD70D12.5030404@gmail.com>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
	 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also added Doug to CC, hopefully we now have everybody who pokes at this
stuff.

On Tue, 2012-06-12 at 17:34 +0800, Charles Wang wrote:
> consider following case:
> 
> 5HZ+1
> | cpu0_load     cpu1    cpu2    cpu3    calc_load_tasks
> |    1           1       1       1      
> |  -->calc_load                             1
> |    1           1       1       1      
> |              -->calc_load                 2
> |    0           0       1       0
> |                      -->calc_load         2+1-3=1

Not sure but last time I did the math 2+1-3 ended up being 0.

> |    1           1       0       1      
> |                            -->calc_load   1-1=0
> V
> 5HZ+11     -->calc_global_load              0
>
> actually the load should be around 3, but shows nearly 0.
> 
> 1 tick is much long for some workloads. 

Yes, one tick is long for some stuff, but seeing we sample once every 5
seconds a little fuzz around sampling the nr_running+nr_uninterruptible
thing shouldn't be too bad.

But I think I see what you're getting at.. lemme get more tea and ponder
this a bit.
