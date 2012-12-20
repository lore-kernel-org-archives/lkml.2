Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2LTNua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:50:30 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55228 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2LTNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
References: <20121212100338.GS1009@suse.de>
	<CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
Date: Thu, 20 Dec 2012 21:50:21 +0800
Message-ID: <CAGjg+kG0KwX+skxTqzzwEs=2Gn9M_p83GCxEu-+5twDH+MsQ4g@mail.gmail.com>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
From: Alex Shi <lkml.alex@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 7:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
>> This is a pull request for "Automatic NUMA Balancing V11". The list
>
> Ok, guys, I've pulled this and pushed out. There were some conflicts
> with both the VM changes and with the scheduler tree, but they were
> pretty small and looked simple, so I fixed them up and hope they all
> work.
>
> Has anybody tested the impact on single-node systems? If distros

I tested your tree till this patch set under our lkp testing system,
with benchmark kbuild, aim9-mutitask, specjbb2005 -openjdk/jrockit,
hackbench-process/thread, sysbench -fileio-cfq, multiple loop back
netperf, on 2 laptops, SNB i7, and WSM i5.
only aim9-mutitask-nl (2000 loads, increment 100) has about 2%
performance drop on both of machine.
all others has no clear performance change.


> enable this by default (and it does have 'default y', which is a big
> no-no for new features - I undid that part) then there will be tons of
> people running this without actually having multiple sockets. Does it
> gracefully avoid pointless overheads for this case?
>
