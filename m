Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2GZJmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:42:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:42122 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2GZJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:42:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171659313"
Message-ID: <501110FD.9070308@intel.com>
Date: Thu, 26 Jul 2012 17:42:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 1/2] sched: recover SD_WAKE_AFFINE in select_task_rq_fair
 and code clean up
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com> <1343295457.6863.43.camel@marge.simpson.net>
In-Reply-To: <1343295457.6863.43.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:37 PM, Mike Galbraith wrote:

> On Thu, 2012-07-26 at 13:27 +0800, Alex Shi wrote:
> 
>> 	if (affine_sd) {
>> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
>> +		if (wake_affine(affine_sd, p, sync))
>>  			prev_cpu = cpu;
>>  
>>  		new_cpu = select_idle_sibling(p, prev_cpu);
> 
> Hm, if cpu == prev_cpu, asking wake_affine() if it's ok to put wakee
> back where it came from is wasted cycles.. that's where the task is
> headed regardless of reply.


Sure. You'r right.

> 
> -Mike
> 


