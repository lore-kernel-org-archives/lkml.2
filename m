Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2EXJEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:04:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:29478 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2EXJD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:03:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170774395"
Message-ID: <4FBDF91C.7050902@intel.com>
Date: Thu, 24 May 2012 17:02:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: borislav.petkov@amd.com, arnd@arndb.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com> <1337782555-8088-9-git-send-email-alex.shi@intel.com> <4FBD18D20200007800085951@nat28.tlf.novell.com> <1337792984.9783.37.camel@laptop> <4FBDF200.7060608@intel.com> <4FBE11EB0200007800085BD0@nat28.tlf.novell.com>
In-Reply-To: <4FBE11EB0200007800085BD0@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> I just measured the cost of this function on my Romely EP(32 LCPUs) with
>> cpumask_t and NR_CPUS = 32/256/512/4096, the cost are similar with
>> 256/512/4096 and that increased about 20% time cost from 32.
>>
>> I also tried to use cpumask_var_t and alloc it in heap(use
>> CPUMASK_OFFSTACK), actually, it cost same time with cpumask_t in stack.
>> But, the allocation bring another big cost. So, I use cpumask_t in stack.
>> The performance gain data in commit log is getting with NR_CPUS = 256.
> 
> Perhaps using a per-CPU cpumask would be the better choice here


See.

> (I can't see how preemption could validly be enabled when this
> code is utilized).


Sorry, What's your meaning here?, the function is always in pre-empt
safe mode.

> 
> Jan
> 


