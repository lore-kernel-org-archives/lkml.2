Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822Ab2EQBsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:48:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:9471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab2EQBsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153850159"
Message-ID: <4FB45882.3010806@intel.com>
Date: Thu, 17 May 2012 09:46:42 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, riel@redhat.com, luto@mit.edu,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH v5 5/7] x86/tlb: add tlb_flushall_shift for specific CPU
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com> <1337072138-8323-6-git-send-email-alex.shi@intel.com> <4FB34DFB.2040902@intel.com> <4FB3E9FE.5020902@zytor.com>
In-Reply-To: <4FB3E9FE.5020902@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 01:55 AM, H. Peter Anvin wrote:

> On 05/15/2012 11:49 PM, Alex Shi wrote:
>> +	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
>> +			|| tlb_flushall_shift == (u16)TLB_FLUSH_ALL) {
> 
> I asked for you to fold the cpu_has_invlpg test into tlb_flushall_shift.
>  Also, (u16)TLB_FLUSH_ALL really is hit up with the ugly stick... why on
> earth is this u16?  It's a bit shift, so it can't be bigger than 6 bits
> anyway... and if you want to be able to use -1 as a sentinel you might
> as well make it a signed value and use < 0 or == -1 as the test.


!cpu_has_invlpg be moved in next patch, but surely, it is better to be
removed here too.

Sure, u16 make code looks ugly. So, s8 is better and worth to add value
check on later knob patch. Since this change cause later patch
modification. I am going to re-update whole patches.
>

> Am I missing something really fundamental here?


No.

> 
> 	-hpa
> 


