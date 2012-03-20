Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab2CTLtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab2CTLtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:49:31 -0400
Message-ID: <4F686E83.3030907@redhat.com>
Date: Tue, 20 Mar 2012 13:48:19 +0200
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
References: <20120316144028.036474157@chello.nl>      <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>     <4F671B90.3010209@redhat.com> <1332158992.18960.316.camel@twins>    <4F672384.1030601@redhat.com> <1332187387.18960.389.camel@twins>   <4F685960.4080904@redhat.com> <1332240525.18960.403.camel@twins>  <4F686163.40509@redhat.com> <1332241633.18960.406.camel@twins>
In-Reply-To: <1332241633.18960.406.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 01:07 PM, Peter Zijlstra wrote:
> On Tue, 2012-03-20 at 12:52 +0200, Avi Kivity wrote:
>
> > You use the dma engine for eager copying, not on demand.
>
> Sure, but during that time no access to that entire vma is allowed, so
> you have to unmap it, and any fault in there will have to wait for the
> entire copy to complete.
>
> Or am I misunderstanding how things would work?

Option 1: write-protect the area you are migrating, on write fault allow
write access and discard the migration target (marking the page for
migration later)

Option 2: clear the dirty bits on the area you are migrating, after
migration completes examine the dirty bit, and if dirty, discard the
migration target.

-- 
error compiling committee.c: too many arguments to function

