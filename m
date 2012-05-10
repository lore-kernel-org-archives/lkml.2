Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2EJJG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:06:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:1552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab2EJJGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151328124"
Message-ID: <4FAB84B6.7060706@intel.com>
Date: Thu, 10 May 2012 17:04:54 +0800
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
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-4-git-send-email-alex.shi@intel.com> <20120510084213.GD30055@aftab.osrc.amd.com>
In-Reply-To: <20120510084213.GD30055@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +#define FLUSHALL_BAR	16
>> +
> 
> Btw, you can save a bunch of indenting on this function, let me add
> the final version here from the whole patchset so I can comment on it
> easier:
> 
>> void __flush_tlb_range(struct mm_struct *mm, unsigned long start,
>>                                 unsigned long end, unsigned long vmflag)
>> {
>>         preempt_disable();
>>         if (current->active_mm == mm) {
> 
> 	if (current->active_mm != mm)
> 		goto flush_all;
> 
> Now this whole piece below can move one indentation level to the left.
> 
> Then you can do:
> 
> 	if (!current->mm)
> 		goto leave;
> 
> and add the "leave" label below.
> 
> Now you're saving yet another indentation level, bringing the meat of
> the function at 1st indentation level, which is cool and gives you much
> more room so that you don't have to linebreak longer statements.
> 


sure, thanks! :)
