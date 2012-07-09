Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2GIOyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2GIOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:54:11 -0400
Message-ID: <4FFAF067.3050905@redhat.com>
Date: Mon, 09 Jul 2012 10:53:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 25/26] sched, numa: Only migrate long-running entities
References: <20120316144028.036474157@chello.nl>  <20120316144241.749359061@chello.nl> <4FF9D29D.8030903@redhat.com> <1341836787.3462.64.camel@twins>
In-Reply-To: <1341836787.3462.64.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 08:26 AM, Peter Zijlstra wrote:
> On Sun, 2012-07-08 at 14:34 -0400, Rik van Riel wrote:

>> Do we really want to calculate the amount of CPU time used
>> by a process, and start migrating after just one second?
>>
>> Or would it be ok to start migrating once a process has
>> been scanned once or twice by the NUMA code?
>
> You mean, the 2-3rd time we try and migrate this task, not the memory
> scanning thing as per Andrea, right?

Indeed.  That way we can simply keep a flag somewhere,
instead of iterating over the threads in a process.

-- 
All rights reversed
