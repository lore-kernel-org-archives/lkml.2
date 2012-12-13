Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2LMNw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:52:28 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53025 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2LMNw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:52:27 -0500
Date: Thu, 13 Dec 2012 18:51:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/49] Automatic NUMA Balancing v10
Message-ID: <20121213132148.GD29086@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121313-7182-0000-0000-000003C2A819
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [2012-12-07 10:23:03]:

> This is a full release of all the patches so apologies for the flood.  V9 was
> just a MIPS build fix and did not justify a full release. V10 includes Ingo's
> scalability patches because even though they increase system CPU usage,
> they also helped in a number of test cases. It would be worthwhile trying
> to reduce the system CPU usage by looking closer at how rwsem works and
> dealing with the contended case a bit better. Otherwise the rate of change
> in the last few weeks has been tiny as the preliminary objectives had been
> met and I did not want to invalidate any testing other people had conducted.
> 
> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git mm-balancenuma-v10r3
> git tag:  git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git mm-balancenuma-v10

Here are the specjbb results on a 2 node 24 GB machine.
vm_1 was allocated 12 GB, while vm_2 and vm_3 were allocated 6 GB each
All vms were running specjbb2005 workload

All numbers presented are improvements/regression from v3.7-rc8

----------------------------------------------------------------------------------------------
|                      |     |                          nofit|                            fit|
----------------------------------------------------------------------------------------------
|                      |     |          noksm|            ksm|          noksm|            ksm|
----------------------------------------------------------------------------------------------
|                      |     |  nothp|    thp|  nothp|    thp|  nothp|    thp|  nothp|    thp|
----------------------------------------------------------------------------------------------
| autonuma-mels-rebase | vm_1|   2.48|  14.25|   1.80|  15.59|   8.16|  14.62|   8.56|  17.49|
| autonuma-mels-rebase | vm_2|  23.59|  18.67|  14.20|  23.25|  10.73|  13.18|  17.94|  21.72|
| autonuma-mels-rebase | vm_3|  16.19|  19.40|  14.42|  22.54|  11.08|  12.04|   9.79|  20.34|
----------------------------------------------------------------------------------------------
| mel-balancenuma v10r3| vm_1|   0.10|   1.49|   1.78|   4.00|  -1.01|  -1.16|  -1.02|  -0.60|
| mel-balancenuma v10r3| vm_2|   3.45|  -0.67|  -1.54|   2.65|  -2.83|  -7.10|   0.10|  -2.41|
| mel-balancenuma v10r3| vm_3|   0.56|   5.49|  -0.63|   0.09|  -7.41|  -4.52|  -0.77|  -1.80|
----------------------------------------------------------------------------------------------
| tip-master 11-dec    | vm_1|  -5.68|  12.34|  35.96|  13.33|  10.79|  15.22|   9.65|  12.80|
| tip-master 11-dec    | vm_2|  14.70|  15.54|  77.45|  15.10|  12.82|  11.20|  12.66|  na   |
| tip-master 11-dec    | vm_3|   6.66|  19.26|  na   |  14.93|   7.62|  14.72|  14.73|  12.34|
----------------------------------------------------------------------------------------------


there are couple na's .. In those case, the testlog for some wierd
reason didnt have any data. this somehow seems to happen with tip/master
kernel only. May be its just coincidence.

-- 
Thanks and Regards
Srikar

PS: benchmark was run under non-standard conditions run only for the
purpose of relative comparision of different kernels.

