Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2E2Qre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:47:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2E2Qrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:47:33 -0400
Message-ID: <4FC4FD51.2080001@redhat.com>
Date: Tue, 29 May 2012 12:46:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com> <1337965359-29725-14-git-send-email-aarcange@redhat.com> <1338297385.26856.74.camel@twins> <20120529163849.GF21339@redhat.com>
In-Reply-To: <20120529163849.GF21339@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 12:38 PM, Andrea Arcangeli wrote:
> On Tue, May 29, 2012 at 03:16:25PM +0200, Peter Zijlstra wrote:
>> 24 bytes per page.. or ~0.6% of memory gone. This is far too great a
>> price to pay.
>
> I don't think it's too great, memcg uses for half of that and yet
> nobody is booting with cgroup_disable=memory even on not-NUMA servers
> with less RAM.

Not any more.

Ever since the memcg naturalization work by Johannes,
a page is only ever on one LRU list and the memcg
memory overhead is gone.

> But I'm all for experimenting. It's just not something I had the time
> to try yet. I will certainly love to see how it performs by reducing
> the max size of the list. I totally agree it's a good idea to try it
> out, and I don't exclude it will work fine, but it's not obvious it's
> worth the memory saving.

That's fair enough.

-- 
All rights reversed
