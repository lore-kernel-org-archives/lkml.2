Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2EaFrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:47:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38687 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2EaFro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:47:44 -0400
Date: Thu, 31 May 2012 11:15:33 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -V7 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
Message-ID: <20120531054533.GE24855@skywalker.linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205301801060.25774@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301801060.25774@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053019-0260-0000-0000-0000014344FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 06:02:59PM -0700, David Rientjes wrote:
> On Wed, 30 May 2012, Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> > VM_FAULT_* values will not exceed MAX_ERRNO value.  Decouple the
> > VM_FAULT_* values from MAX_ERRNO.
> > 
> 
> Yeah, but is there a reason for using VM_FAULT_HWPOISON_LARGE_MASK since 
> that's the only VM_FAULT_* value that is greater than MAX_ERRNO?  The rest 
> of your patch set doesn't require this, so I think this change should just 
> be dropped.  (And PTR_ERR() still returns long, this wasn't fixed from my 
> original review.)
> 

The changes was done as per Andrew's request so that we don't have such hidden
dependencies on the values of VM_FAULT_*. Yes it can be a seperate patch from
the patchset. I have changed int to long as per your review.

-aneesh

