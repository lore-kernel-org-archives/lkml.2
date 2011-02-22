Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1BVVrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:47:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:53119 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1BVVrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:47:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,208,1297065600"; 
   d="scan'208";a="605461674"
Message-ID: <4D642F03.5040800@linux.intel.com>
Date: Tue, 22 Feb 2011 13:47:47 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        lwoodman@redhat.com
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-7-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102221333100.5929@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102221333100.5929@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2011 1:42 PM, David Rientjes wrote:
>
> This makes the accounting worse, NUMA_LOCAL is defined as "allocation from
> local node," meaning it's local to the allocating cpu, not local to the
> node being targeted.

Local to the process really (and I defined it originally ...)  That is 
what I'm implementing

I don't think "local to some random kernel daemon which changes mappings 
on behalf of others"
makes any sense as semantics.

> Further, preferred_zone has taken on a much more significant meaning other
> than just statistics: it impacts the behavior of memory compaction and how
> long congestion timeouts are, if a timeout is taken at all, depending on
> the I/O being done on behalf of the zone.
>
> A better way to address the issue is by making sure preferred_zone is
> actually correct by using the appropriate zonelist to be passed into the
> allocator in the first place

That is what is done already (well for THP together with my other patches)
The problem is just that local_hit/miss still uses numa_node_id() and 
not the preferred zone
to do the accounting.  In most cases that's fine and intended, just not 
for these
special daemons.


-Andi

