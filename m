Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1FPSod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:44:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:63184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1FPSob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,376,1304319600"; 
   d="scan'208";a="14421212"
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308249362.13240.275.camel@twins>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308071218-5912-2-git-send-email-tj@kernel.org>
	 <1308226372.13240.42.camel@twins>
	 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1308246910.13240.238.camel@twins>
	 <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
	 <20110616182805.GD2611@htj.dyndns.org>  <1308249362.13240.275.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 16 Jun 2011 11:44:31 -0700
Message-Id: <1308249871.2682.461.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 11:36 -0700, Peter Zijlstra wrote:
> On Thu, 2011-06-16 at 20:28 +0200, Tejun Heo wrote:
> > Peter, I don't think it's that simple.  get_online_cpus() itself can't
> > create circular dependency by itself.  It allows recursing.  The chain
> > involves cpu_hotplug_begin() which returns with hotplug mutex held.
> 
> 
> Right, its like:
> 
>  mutex_lock(&a);
>  get_online_cpus();
> 
> vs
> 
>  cpu_hotplug_begin()
>  mutex_lock(&a);
> 
> 
> that will really deadlock

Its actually like:

get_online_cpus();
mutex_lock(&a);
get_online_cpus(); <--- recursive get_online_cpus()

vs

cpu_hotplug_begin()
mutex_lock(&a);

So it can't cause deadlock in practice.

thanks,
suresh

