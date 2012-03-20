Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2CTAF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61892 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2CTAFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120319202846.GA26555@gmail.com>
References: <20120316144028.036474157@chello.nl> <4F670325.7080700@redhat.com>
 <1332155527.18960.292.camel@twins> <20120319130401.GI24602@redhat.com>
 <1332164371.18960.339.camel@twins> <20120319142046.GP24602@redhat.com>
 <alpine.DEB.2.00.1203191513110.23632@router.home> <20120319202846.GA26555@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Mar 2012 17:05:33 -0700
X-Google-Sender-Auth: WHLwPF-lBVRNeVWZWIJnLtHz01A
Message-ID: <CA+55aFwa-81x2Dysk8WS8ez2WkYSbaQDyQvpH0qE7fGJgxTbUQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/26] sched/numa
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> That having said PeterZ's numbers showed some pretty good
> improvement for the streams workload:
>
>  before: 512.8M
>  after: 615.7M
>
> i.e. a +20% improvement on a not very heavily NUMA box.

Well, streams really isn't a very interesting benchmark. It's the
traditional single-threaded cpu-only thing that just accesses things
linearly, and I'm not convinced the numbers should be taken to mean
anything at all.

The HPC people want to multi-thread things these days, and "cpu/memory
affinity" is a lot less clear then.

So I can easily imagine that the performance improvement is real, but
I really don't think "streams improves by X %" is all that
interesting. Are there any more relevant loads that actually matter to
people that we could show improvement on?

                     Linus
