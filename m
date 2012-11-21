Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KUBAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:00:24 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35088 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2KUBAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:00:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+1xoqcbPGpFvhJG3OMDYBPMD0+1umJv1wyE-b+KHtKi_s4unQ@mail.gmail.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
 <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
 <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com>
 <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com>
 <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com>
 <CA+1xoqe74R6DX8Yx2dsp1MkaWkC1u6yAEd8eWEdiwi88pYdPaw@mail.gmail.com>
 <alpine.DEB.2.00.1210241633290.22819@chino.kir.corp.google.com>
 <CA+1xoqd6MEFP-eWdnWOrcz2EmE6tpd7UhgJyS8HjQ8qrGaMMMw@mail.gmail.com>
 <alpine.DEB.2.00.1210241659260.22819@chino.kir.corp.google.com>
 <1351167554.23337.14.camel@twins> <1351175972.12171.14.camel@twins>
 <CA+55aFzoxMYLXdBvdMYTy_LhrVuU233qh1eDyAda5otUTHojPA@mail.gmail.com>
 <1351241323.12171.43.camel@twins> <CA+1xoqcbPGpFvhJG3OMDYBPMD0+1umJv1wyE-b+KHtKi_s4unQ@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 20 Nov 2012 19:59:57 -0500
Message-ID: <CA+1xoqevFYQqBOKWZAL5ye6Mef+ZJkTra7UzOTkGmeCJmm-LPA@mail.gmail.com>
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in numa_maps
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Can someone take it before it's lost?

On Wed, Oct 31, 2012 at 2:29 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Fri, Oct 26, 2012 at 4:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2012-10-25 at 16:09 -0700, Linus Torvalds wrote:
>>> On Thu, Oct 25, 2012 at 7:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> >
>>> > So I think the below should work, we hold the spinlock over both rb-tree
>>> > modification as sp free, this makes mpol_shared_policy_lookup() which
>>> > returns the policy with an incremented refcount work with just the
>>> > spinlock.
>>> >
>>> > Comments?
>>>
>>> Looks reasonable, if annoyingly complex for something that shouldn't
>>> be important enough for this. Oh well.
>>
>> I agree with that.. Its just that when doing numa placement one needs to
>> respect the pre-existing placement constraints. I've not seen a way
>> around this.
>>
>>> However, please check me on this: the need for this is only for
>>> linux-next right now, correct? All the current users in my tree are ok
>>> with just the mutex, no?
>>
>> Yes, the need comes from the numa stuff and I'll stick this patch in
>> there.
>>
>> I completely missed Mel's patch turning it into a mutex, but I guess
>> that's what -next is for :-).
>
> So I've been fuzzing with it for the past couple of days and it's been
> looking fine with it. Can someone grab it into his tree please?
>
>
> Thanks,
> Sasha
