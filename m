Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2EON3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:29:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:27273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab2EON3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143390771"
Message-ID: <4FB25A12.1050506@intel.com>
Date: Tue, 15 May 2012 21:28:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org, jcm@jonmasters.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com> <1337072138-8323-7-git-send-email-alex.shi@intel.com> <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com> <CAPa8GCADw7cn+cGukfy6=gEJAqV2Ef3=YFcPriuPmhpE-xvX7A@mail.gmail.com> <CAJRGBZy0S_fg3GY4S5CG-2SWv5AG1jMrcMMqCiTg=7xyD1mrzQ@mail.gmail.com> <1337087170.27020.166.camel@laptop> <CAJRGBZyJy416yeyTgrcBR6b-7Y+cBXiz91f_gscRSado1wQVhg@mail.gmail.com>
In-Reply-To: <CAJRGBZyJy416yeyTgrcBR6b-7Y+cBXiz91f_gscRSado1wQVhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 09:27 PM, Luming Yu wrote:

> On Tue, May 15, 2012 at 9:06 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Tue, 2012-05-15 at 20:58 +0800, Luming Yu wrote:
>>>
>>>
>>> Both __native_flush_tlb() and __native_flush_tlb_single(...)
>>> introduced roughly 1 ns  latency to tsc sampling executed in
> 
> Fix typo, I just observed 1us with current tool, I would check if I
> can push the accuracy to nanoseconds level.
> 
>>> stop_machine_context in two logical CPUs
>>
>> But you have to weight that against the cost of re-population, and
> 
> Right, it's hard to detect, but I will try if I can get measurement
> done in a simple test tool to help people measure
> this kind of stuff in few minutes.
> 
>> that's the difficult bit, since we have no clue how many tlb entries are
>> in use by the current cr3.
>>
>> It might be possible for intel to give us this information, I've asked
>> for something similar for cachelines.
> 
> This is the official document
> http://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
> 


Please, such huge documents! and it also has no such info.

> Let me know if it can answer your question.
> 
>>


