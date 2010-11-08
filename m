Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KHCbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:31:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:48273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0KHCbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:31:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,311,1286175600"; 
   d="scan'208";a="855128712"
Date: Mon, 8 Nov 2010 09:45:27 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Youquan Song <youquan.song@linux.intel.com>, davej@redhat.com,
        venki@google.com, youquan.song@intel.com, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Fix ondemand governor powersave_bias
	execution time misuse
Message-ID: <20101108144527.GA13617@linux-youquan.bj.intel.com>
References: <20101105151951.GA10743@linux-youquan.bj.intel.com> <4CD3EF31.9060909@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD3EF31.9060909@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/5/2010 11:19 AM, Youquan Song wrote:
>> Ondemand governor use powersave_bias tunable to do aggressive power save by
>> decrease CPU average frequency. The average frequency achieve by adjust low and
>> high frequency's execution time proportion during one sample time interval.
>>
>> Current kernel, only the high frequency executes in time proportion, but the low
>> frequency wrongly execute in one whole sample time interval when powersave_bias
>> is set.
>>
>> The patch fix it by set low frequency execution time to it deserved.
>>
>> Signed-off-by: Youquan Song<youquan.song@intel.com>
>> ---
>
>
> while your patch looks correct, I think the whole feature is wonky and 
> likely ought to be removed...........

powersave_bias should be a useful feature, which give user an
opportunity to set the CPU to work at wider average frequency accord to real
 workload requirement, not just CPU frequency specific at P0,P1,...Pn.
At the same time, it meets end user power comsumpation requirement in
some degree. 
Unfortunately, it does not work for a long time.

Thanks
-Youquan
