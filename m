Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2EVAS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:18:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:46061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759571Ab2EVASU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155417147"
Message-ID: <4FBADAED.1010807@intel.com>
Date: Tue, 22 May 2012 08:16:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, jbeulich@suse.com,
        rostedt@goodmis.org, ak@linux.intel.com, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, akinobu.mita@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86/tlb: replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR
References: <1337353963-8294-1-git-send-email-alex.shi@intel.com> <4FB7004B.4010806@intel.com>
In-Reply-To: <4FB7004B.4010806@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 10:07 AM, Alex Shi wrote:

> On 05/18/2012 11:12 PM, Alex Shi wrote:
> 
>> There are only 32 INVALIDATE_TLB_VECTOR now in kernel.
>> but modern x86 sever has more cpu number. That causes lock
>> contention in TLB flushing.
>>
>> Now, useing generic smp call function to replace it.
>> In the NHM EX machine 4P * 8cores * HT = 64 CPUs, hackbench pthread
>> has 3% performance increase.
>> And no clear performance changes on NHM EP(16CPUs), WSM EP(23CPU)
>> and SNB EP(32CPU) machines.
>>
>> This patch is base on my tlb flush range support patchset.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> 
> 
> refresh this patch will more clean up, and cc to PeterZ.
> Actually, I tried to keep flush_tlb_info into dedicated cache line, but did find clear help.


Correct: I did _not_ find clear help for dedicated cache line for
flush_tlb_info.

> 
> Comments are appreciated!
> 


Any comments for this patch?
