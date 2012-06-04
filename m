Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab2FDKuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:50:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:44118 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab2FDKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:50:24 -0400
Message-ID: <4FCC92EC.2000808@parallels.com>
Date: Mon, 4 Jun 2012 14:50:20 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120425 Thunderbird/10.0.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com> <1338805967.28282.12.camel@twins>
In-Reply-To: <1338805967.28282.12.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 02:32 PM, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 14:24 +0400, Vladimir Davydov wrote:
>> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
>> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
>> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
>> decisions, which can negatively affect overall performance.
>>
>> To cope this, use nr_running last seen in __update_cpu_load() instead of
>> cpuload for calculating performance multiplier.
> What is cpuidle trying to do?

Basing on cpuload, it selects idle state. The less the load, the lowest 
the state.
