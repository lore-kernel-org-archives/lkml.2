Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab2FDPOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:14:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:20030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab2FDPOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160383227"
Message-ID: <4FCCD0CD.8080700@linux.intel.com>
Date: Mon, 04 Jun 2012 08:14:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>   <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>  <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com> <1338822509.28282.65.camel@twins>
In-Reply-To: <1338822509.28282.65.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 8:08 AM, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 06:48 -0700, Arjan van de Ven wrote:
>> it's not about busy, it's about performance sensitive.
>> it's not a super nice proxy, no argument, but it's one of the few long
>> term ones we have.
>>
> I'm still not seeing how it makes any sense at all. Is there an actual
> workload here this matters?

yes there are, mostly server ones.

the problem isn't an individual idle, it's that the 100us-200us
latencies add up if you go in and out repeatedly, when the system is in
a situation where it is sensitive to performance (which is not an
instant thing, this is a "over the long run we're busy" thing)...
... they become a real factor.

now, "performance sensitive" is highly elusive and unmeasureable, but
load average is a reasonable approximation... well, the best we have.
(just cpu usage is not, you can have low cpu usage but block on
semaphores or IO all the time, and you're still sensitive to performance)
