Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2FNBMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:12:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:64936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab2FNBMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156095459"
Message-ID: <4FD939F2.3090605@intel.com>
Date: Thu, 14 Jun 2012 09:10:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, android-kernel@googlegroups.com
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, penberg@kernel.org,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 8/8] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
References: <1339492005-20241-1-git-send-email-alex.shi@intel.com> <1339492005-20241-9-git-send-email-alex.shi@intel.com> <20120613145656.GB32604@tassilo.jf.intel.com>
In-Reply-To: <20120613145656.GB32604@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 10:56 PM, Andi Kleen wrote:

> On Tue, Jun 12, 2012 at 05:06:45PM +0800, Alex Shi wrote:
>> This patch do flush_tlb_kernel_range by 'invlpg'. The performance pay
>> and gain was analysed in my patch (x86/flush_tlb: try flush_tlb_single
>> one by one in flush_tlb_range). Now we move this logical into kernel
>> part. The pay is multiple 'invlpg' execution cost, that is same. but
>>  the gain(cost reducing of TLB entries refilling) is absolutely
>> increased.
> 
> The subtle point is whether INVLPG flushes global pages or not.
> After some digging I found a sentence in the SDM that says it does.
> So it may be safe.


Many thanks for your time!

> 
> What does it improve?


I have not specific benchmark for this. partly due to the gain theory
was proved since it is same as previous user process's page table flush.

The user of tlb kernel flush in kernel is vmalloc. and Android binder
IPC subsystem is using it(drivers/staging/android/binder.c)

I am wondering if it can help Andriod on this?
So, add cc to android-kernel@googlegroups.com

> -Andi


