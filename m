Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2GZJLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:11:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:21010 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2GZJLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:11:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173395181"
Message-ID: <501109DD.7020501@intel.com>
Date: Thu, 26 Jul 2012 17:11:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] sched: fix a logical error in select_task_rq_fair
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>  <1343280446-24019-2-git-send-email-alex.shi@intel.com> <1343290631.26034.86.camel@twins>
In-Reply-To: <1343290631.26034.86.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:17 PM, Peter Zijlstra wrote:

> On Thu, 2012-07-26 at 13:27 +0800, Alex Shi wrote:
>> If find_idlest_cpu() return '-1', and sd->child is NULL. The function
>> select_task_rq_fair will return -1. That is not the function's purpose.
> 
> But find_idlest_cpu() will only return -1 if the group mask is fully
> excluded by the cpus_allowed mask, right?


Yes.

> 
> In that case aren't we covering up a bug in find_idlest_group(), it
> appears to have returned a group that isn't eligible to be idlest.


If it is possible happening in sched_domain rebuilding?
I didn't meet this bug. Just guess.

> 
> 


