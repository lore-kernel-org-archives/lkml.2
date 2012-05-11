Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2EKAvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:51:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:3939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2EKAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:51:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98762010"
Message-ID: <4FAC621D.2020704@intel.com>
Date: Fri, 11 May 2012 08:49:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific
 CPU
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>  <1336626013-28413-6-git-send-email-alex.shi@intel.com> <1336642715.2527.84.camel@twins>
In-Reply-To: <1336642715.2527.84.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 05:38 PM, Peter Zijlstra wrote:

> On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> 
> 
>> +void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
>> +{
>> +       if (!cpu_has_invlpg) {
>> +               tlb_flushall_factor = -1;
>> +               return;
>> +       }
> 
> ...
> 
>> +       if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
>> +                       || tlb_flushall_factor == (u16)TLB_FLUSH_ALL)
>> {
>>  flush_all: 
> 
> Since you set tlb_flushall_factor (I'd have called it _shift) to -1
> when !invlpg there's a redundant check in there.
> 



NO, the first judgement is from CPU. But second '-1' is may from user
setting in sysfs.
