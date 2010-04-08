Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0DHJIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:08:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0DHJIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:08:07 -0400
Message-ID: <4BBD9C5A.90307@cn.fujitsu.com>
Date: Thu, 08 Apr 2010 17:05:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lock's trace events can improve mutex's performance in userspace?
References: <4B98BB50.1000002@cn.fujitsu.com>	 <4B9B1416.5020101@dcl.info.waseda.ac.jp> <n2k8d20b11a1004050214m529fa5e7ke31a2213728ea511@mail.gmail.com>
In-Reply-To: <n2k8d20b11a1004050214m529fa5e7ke31a2213728ea511@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

Michel Lespinasse wrote:
> Sorry for the late reply...
> 
> One thing to consider in locking micro-benchmarks is that often, code
> changes that slow down parts of the contended code path where the lock
> is not held, will result in an increase of the reported
> micro-benchmark metric. This effect is particularly marked for
> micro-benchmarks that consist of multiple threads doing empty
> acquire/release loops.
> 
> As a thought experiment, imagine what would happen if you added a
> one-millisecond sleep in the contended code path for mutex
> acquisition. Soon all but one of your benchmark threads would be
> sleeping, and the only non-sleeping thread would be able to spin on
> that lock/unlock loop with no contention, resulting in very nice
> results for the micro-benchmark. Remove the sleep and the lock/unlock
> threads will have to contend, resulting in lower reported performance
> metrics.

Great thanks for your valuable reply that makes we see the
issue more clearly.

I've do the test address your conjecture that add usleep(1) in mutex
acquisition path, the test result shows contention is reduced.

And i also do the test that does more work in mutex holding path, the
result shows optimization ratio is decreased.

Thanks,
Xiao
