Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab0FRR3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:29:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842Ab0FRR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:29:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6017"; a="44704518"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C1B2864.6010305@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org>	<1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org>	<1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org>	<1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org>
	 <20100617161539.d4ea62c0.akpm@linux-foundation.org>
	 <4C1B2864.6010305@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 10:29:26 -0700
Message-ID: <1276882166.30433.49.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 10:03 +0200, Tejun Heo wrote:

> > I share Daniel's concerns here.  Being able to set a worker thread's
> > priority or policy isn't a crazy thing.
> 
> Well, priority itself isn't but doing that from userland is and most
> of the conversation was about cmwq taking away the ability to do that
> from userland.

I did a little test of this on v2.6.31 with my laptop.

I used this test along with "fio" ,

[random-read]
rw=randread
size=128m
directory=/tmp/

and I got these results,

clat (usec): min=196, max=185962, avg=11820.81, stdev=5961.96
bw (KB/s) : min=   67, max=  665, per=100.20%, avg=337.68, stdev=36.55

then I raise the priority of kblockd to FIFO priority 50 with the
following results,

clat (usec): min=198, max=118528, avg=11749.48, stdev=5280.79
bw (KB/s) : min=  184, max=  696, per=100.20%, avg=339.66, stdev=32.98

We ended up with a %36 max latency reduction, a slight increase in the
min latency (~%2) and a slight decrease in the average latency. The
latency became more deterministic ..

Now for the bandwidth we have a ~%5 maximum bandwidth increase, a huge
increase in minimum bandwidth (%174 am I calculating that right?), and a
slight increase in the average (%0.5) ..

These results are just one off, so please re-test and check up on me.
I'm not very familiar with "fio" or kblockd in general.

However, these results seem far from crazy to me .. In fact I think
people who really care about this sort of stuff might want to look into
this type of tuning .. You get more deterministic latency, and you get
slightly better performance in the average but way better performance in
the corner cases.

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

