Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2E2N5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab2E2N5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:57:32 -0400
Message-ID: <4FC4D58A.50800@redhat.com>
Date: Tue, 29 May 2012 09:56:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
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
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>  <1337965359-29725-14-git-send-email-aarcange@redhat.com> <1338297385.26856.74.camel@twins>
In-Reply-To: <1338297385.26856.74.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 09:16 AM, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:

> 24 bytes per page.. or ~0.6% of memory gone. This is far too great a
> price to pay.
>
> At LSF/MM Rik already suggested you limit the number of pages that can
> be migrated concurrently and use this to move the extra list_head out of
> struct page and into a smaller amount of extra structures, reducing the
> total overhead.

For THP, we should be able to track this NUMA info on a
2MB page granularity.

It is not like we will ever want to break up a large
page into small pages anyway (with different 4kB pages
going to different NUMA nodes), because the THP benefit
is on the same order of magnitude as the NUMA benefit.

-- 
All rights reversed
