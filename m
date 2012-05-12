Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2ELICH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 04:02:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:4719 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2ELICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 04:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142174014"
Message-ID: <4FAE18D0.6050001@intel.com>
Date: Sat, 12 May 2012 16:01:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-4-git-send-email-alex.shi@intel.com> <20120510084213.GD30055@aftab.osrc.amd.com> <4FAB84B6.7060706@intel.com>
In-Reply-To: <4FAB84B6.7060706@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 05:04 PM, Alex Shi wrote:

> 
>>> +
>>> +#define FLUSHALL_BAR	16
>>> +
>>
>> Btw, you can save a bunch of indenting on this function, let me add
>> the final version here from the whole patchset so I can comment on it
>> easier:
>>
>>> void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
>>>                                 unsigned long end, unsigned long vmflag)
>>> {
>>>         preempt_disable();
>>>         if (current->active_mm == mm) {
>>
>> 	if (current->active_mm != mm)
>> 		goto flush_all;
>>
>> Now this whole piece below can move one indentation level to the left.


that is helpful and not imply logical too much.

>>
>> Then you can do:
>>
>> 	if (!current->mm)
>> 		goto leave;
>>
>> and add the "leave" label below.


I tried this, found too many goto and label is worse than line breaking. :(

>>
>> Now you're saving yet another indentation level, bringing the meat of
>> the function at 1st indentation level, which is cool and gives you much
>> more room so that you don't have to linebreak longer statements.
>>
> 
> 
> sure, thanks! :)


