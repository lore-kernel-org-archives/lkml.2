Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2JITFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:05:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:53255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab2JITFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:05:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="232629480"
Message-ID: <5074756C.8070502@intel.com>
Date: Tue, 09 Oct 2012 12:05:16 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com> <20121005200245.GQ16230@one.firstfloor.org> <506F6BF2.8030500@intel.com> <20121006175751.GS16230@one.firstfloor.org> <5072F497.2000703@intel.com>
In-Reply-To: <5072F497.2000703@intel.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 08:43 AM, Alexander Duyck wrote:
> On 10/06/2012 10:57 AM, Andi Kleen wrote:
>> BTW __pa used to be a simple subtraction, the if () was just added to
>> handle the few call sites for x86-64 that do __pa(&text_symbol).
>> Maybe we should just go back to the old __pa_symbol() for those cases,
>> then __pa could be the simple subtraction it used to was again
>> and it could be inlined and everyone would be happy.
>>
>> -Andi
> What I am probably looking at doing is splitting the function in two as
> you suggest where we have a separate function for the text symbol case. 
> I will probably also take the 32 bit approach and add a debug version
> that is still a separate function for uses such as determining if we
> have any callers who should be using __pa_symbol instead of __pa.
>
> Thanks,
>
> Alex

I gave up on trying to split __pa and __pa_symbol.   Yesterday I
realized there is way too much code that depends on the two resolving to
the same function, and many cases are pretty well hidden.  Instead I
just mailed out a patch that inlines an optimized version of
__phys_addr.  I figure it is probably as good as it is going to get
without having to rip the entire x86 portion of the kernel apart to
separate uses of __pa and __pa_symbol.

Thanks,

Alex
