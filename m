Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2EXXU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:20:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51179 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2EXXU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:20:26 -0400
Date: Thu, 24 May 2012 16:20:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org,
        mgorman@suse.de, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <20120524155727.dc6c839e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1205241615540.9453@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
 <20120524155727.dc6c839e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Andrew Morton wrote:

> These arguments look pretty strong to me.  But poorly timed :(
> 

What I argued here is nothing new, I said the same thing back on April 27 
and I was expecting it to be reproposed as a seperate controller.  The 
counter argument that memcg shouldn't cause a performance degradation 
doesn't hold water: you can't expect every page to be tracked without 
incurring some penalty somewhere.  And it certainly causes ~1% of memory 
to be used up at boot with all the struct page_cgroups.

The counter argument that we'd have to duplicate cgroup setup and 
initialization code from memcg also is irrelevant: all generic cgroup 
mounting, creation, and initialization code should be in kernel/cgroup.c.  
Obviously there will be added code because we're introducing a new cgroup, 
but that's not a reason to force everybody who wants to control hugetlb 
pages to be forced to enable memcg.
