Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2EIBmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:42:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:46500 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab2EIBmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138442865"
Message-ID: <4FA9CB38.3080606@intel.com>
Date: Wed, 09 May 2012 09:41:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com> <4FA93946.2000302@zytor.com>
In-Reply-To: <4FA93946.2000302@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 11:18 PM, H. Peter Anvin wrote:

> On 05/08/2012 07:03 AM, Alex Shi wrote:
>>  
>> -	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
>> +	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
>> +				|| !tlb_flushall_factor) {
> 
> OK nevermind on the division by zero, but this yet another test being
> performed.
> 
> If nothing else you could fold these tests and make tlb_flushall_factor
> zero if !cpu_has_invlpg.


Yes, should be.

> 
> 	-hpa
> 


