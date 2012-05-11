Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab2EKMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:53:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:56395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab2EKMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:53:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164938898"
Message-ID: <4FAD0BB9.3070206@intel.com>
Date: Fri, 11 May 2012 20:53:13 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user testing/tuning
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-8-git-send-email-alex.shi@intel.com> <20120510082731.GC30055@aftab.osrc.amd.com> <4FAC62B9.9090304@intel.com> <20120511095136.GE8913@aftab.osrc.amd.com>
In-Reply-To: <20120511095136.GE8913@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:51 PM, Borislav Petkov wrote:

> On Fri, May 11, 2012 at 08:52:09AM +0800, Alex Shi wrote:
>>>> +#ifdef CONFIG_DEBUG_TLBFLUSH
>>
>>>> +static ssize_t __tlb_flushall_factor_store(const char *buf,
>>>> +					size_t count, int smt)
>>>> +{
>>>> +	short factor = 0;
>>>> +
>>>> +	if (sscanf(buf, "%hd", &factor) != 1)
>>>> +		return -EINVAL;
>>>
>>> This means only single-digit factors, right?
>>
>> No, you can try '32' '16' etc. not a 'single-digit'.
> 
> Ah, misread sscanf, nevermind.
> 
>>> Why not use kstrtoul?
>>
>> any advantage of this?
> 
> Well, sscanf uses simple_strto* and those miss overflow checks etc, see
> 33ee3b2e2eb9b4b6c64dcf9ed66e2ac3124e748c for details.


Thanks for reminder!

> 
> Btw, there are other kstrto* functions which you could use to fit better
> the argument type and size passed to tlb_flushall_factor.
> 
> 


