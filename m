Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2EaGuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:50:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62131 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2EaGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:50:20 -0400
Date: Wed, 30 May 2012 23:50:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -V7 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT*
 values
In-Reply-To: <20120531054533.GE24855@skywalker.linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205302331380.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205301801060.25774@chino.kir.corp.google.com>
 <20120531054533.GE24855@skywalker.linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Aneesh Kumar K.V wrote:

> > Yeah, but is there a reason for using VM_FAULT_HWPOISON_LARGE_MASK since 
> > that's the only VM_FAULT_* value that is greater than MAX_ERRNO?  The rest 
> > of your patch set doesn't require this, so I think this change should just 
> > be dropped.  (And PTR_ERR() still returns long, this wasn't fixed from my 
> > original review.)
> > 
> 
> The changes was done as per Andrew's request so that we don't have such hidden
> dependencies on the values of VM_FAULT_*. Yes it can be a seperate patch from
> the patchset. I have changed int to long as per your review.
> 

I think it confuscates the code, can't we just add something like 
BUILD_BUG_ON() to ensure that PTR_ERR() never uses values that are outside 
the bounds of MAX_ERRNO so we'll catch these at compile time if 
mm/hugetlb.c or anything else is ever extended to use such values?
