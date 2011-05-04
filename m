Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1EDUSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:18:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:30701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1EDUSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:18:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="742436674"
Message-ID: <4DC1B47B.1010209@linux.intel.com>
Date: Wed, 04 May 2011 13:18:03 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes
References: <1304533058-18228-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1105041213310.22426@chino.kir.corp.google.com> <4DC1B151.7010300@linux.intel.com> <alpine.DEB.2.00.1105041309001.24395@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105041309001.24395@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Completely agreed, I think that's how it should be patched instead of only
> touching the alloc_pages() allocation; we care much more about local node
> than whether we're using vmalloc.

Right now the problem is you end up in node 0 always and then run out of 
memory
later on it on a large system. That's the problem I'm trying to solve ASAP

The rest is much less important.


-Andi

