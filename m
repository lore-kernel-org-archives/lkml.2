Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006Ab2CSJ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab2CSJ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:58:45 -0400
Message-ID: <4F670325.7080700@redhat.com>
Date: Mon, 19 Mar 2012 11:57:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
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
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
References: <20120316144028.036474157@chello.nl>
In-Reply-To: <20120316144028.036474157@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 04:40 PM, Peter Zijlstra wrote:
> The home-node migration handles both cpu and memory (anonymous only for now) in
> an integrated fashion. The memory migration uses migrate-on-fault to avoid
> doing a lot of work from the actual numa balancer kernl thread and only
> migrates the active memory.
>

IMO, this needs to be augmented with eager migration, for the following
reasons:

- lazy migration adds a bit of latency to page faults
- doesn't work well with large pages
- doesn't work with dma engines

So I think that in addition to migrate on fault we need a background
thread to do eager migration.  We might prioritize pages based on the
active bit in the PDE (cheaper to clear and scan than the PTE, but gives
less accurate information).

-- 
error compiling committee.c: too many arguments to function

