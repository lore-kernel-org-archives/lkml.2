Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1EDUEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:04:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:60922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1EDUEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="742432364"
Message-ID: <4DC1B151.7010300@linux.intel.com>
Date: Wed, 04 May 2011 13:04:33 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes
References: <1304533058-18228-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1105041213310.22426@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105041213310.22426@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Before that's considered, the order of the arguments to
> alloc_pages_exact_node() needs to be fixed.

Good point. I'll send another one.

This is really misleading BTW. Grumble.  Maybe it would be actually 
better to
change the prototype too.


>  The vmalloc_node() calls ensure that the nid is actually set in
>N_HIGH_MEMORY and fails otherwise (we don't fallback to using vmalloc()),
>so it looks like the failures for alloc_pages_exact_node() and
>vmalloc_node() would be different?  Why do we want to fallback for one and
>not the other?

The right order would be to try everything (alloc_pages + vmalloc)
to get it node local, before trying everything else. Right now that's
not how it's done.

-Andi



