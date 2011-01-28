Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1A1APT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:15:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:6057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1A1APS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:15:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,388,1291622400"; 
   d="scan'208";a="380966917"
Message-ID: <4D420A89.3050906@linux.intel.com>
Date: Thu, 27 Jan 2011 16:15:05 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tim Chen <tim.c.chen@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Make vm_acct_memory scalable for large memory allocations
References: <1296082319.2712.100.camel@schen9-DESK> <20110127153642.f022b51c.akpm@linux-foundation.org>
In-Reply-To: <20110127153642.f022b51c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This seems like a pretty dumb test case.  We have 64 cores sitting in a
> loop "allocating" 32MB of memory, not actually using that memory and
> then freeing it up again.
>
> Any not-completely-insane application would actually _use_ the memory.
> Which involves pagefaults, page allocations and much memory traffic
> modifying the page contents.
>
> Do we actually care?

It's a bit like a poorly tuned malloc. From what I heard poorly tuned 
mallocs are quite
common in the field, also with lots of custom ones around.

While it would be good to tune them better the kernel should also have 
reasonable performance
for this case.

The poorly tuned malloc has other problems too, but this addresses at 
least one
of them.

Also I think Tim's patch is a general improvement to a somewhat dumb 
code path.

-Andi

