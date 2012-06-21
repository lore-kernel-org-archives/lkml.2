Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2FUCeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:34:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:23902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab2FUCeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168292781"
Message-ID: <4FE28823.80704@intel.com>
Date: Thu, 21 Jun 2012 10:34:11 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1340208092.21745.114.camel@twins>
In-Reply-To: <1340208092.21745.114.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 12:01 AM, Peter Zijlstra wrote:
> 
> ok, so with this stuff something like:
> 
>   perf stat -ae uncore/event=clockticks/ foo
> 
> will register a counter per cpu, which is somewhat silly since we only
> need one per node. What would be the best way to 'fix' this?
> 
> We could of course create another variant of -a which iterates nodes
> instead of cpus, -N or so.
> 
> Alternatively we could try and describe this in sysfs in some way, one
> possibility would be to include a link to /sys/devices/system/{cpu,node}
> or somesuch and use that link to iterate the correct space.
> 
> Any other suggestions?
> 
How about treat the 'cpu' parameter for uncore event as socket id instead
of cpu id?

Regards
Yan, Zheng


