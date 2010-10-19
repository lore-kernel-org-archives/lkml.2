Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0JSBc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:32:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0JSBc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IkR4isyAYIMH410BIAyZS9ift9LwV2336eRAGF60nRiB3fiwn/qDAkfMIE0K/MVj3B
         yjFsx99of+XH/O7Z6X7LIey4trmDi/x8HSENcdR2dlaUz/aNduAeMNdWA5GCWZhnHwf5
         bRjXWA0EDOTNEAzzDSAbwUXqgm7DUiHxCvt2c=
MIME-Version: 1.0
In-Reply-To: <20101019102114.A1B9.A69D9226@jp.fujitsu.com>
References: <20101019095144.A1B0.A69D9226@jp.fujitsu.com>
	<AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
	<20101019102114.A1B9.A69D9226@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 10:32:27 +0900
Message-ID: <AANLkTinU9qHEGgK5NDLi-zBSXJZmRDoZEnyLOHRYe8rd@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:21 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Tue, Oct 19, 2010 at 9:57 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > I think there are two bugs here.
>> >> > The raid1 bug that Torsten mentions is certainly real (and has been around
>> >> > for an embarrassingly long time).
>> >> > The bug that I identified in too_many_isolated is also a real bug and can be
>> >> > triggered without md/raid1 in the mix.
>> >> > So this is not a 'full fix' for every bug in the kernel :-), but it could
>> >> > well be a full fix for this particular bug.
>> >> >
>> >>
>> >> Can we just delete the too_many_isolated() logic?  (Crappy comment
>> >> describes what the code does but not why it does it).
>> >
>> > if my remember is correct, we got bug report that LTP may makes misterious
>> > OOM killer invocation about 1-2 years ago. because, if too many parocess are in
>> > reclaim path, all of reclaimable pages can be isolated and last reclaimer found
>> > the system don't have any reclaimable pages and lead to invoke OOM killer.
>> > We have strong motivation to avoid false positive oom. then, some discusstion
>> > made this patch.
>> >
>> > if my remember is incorrect, I hope Wu or Rik fix me.
>>
>> AFAIR, it's right.
>>
>> How about this?
>>
>> It's rather aggressive throttling than old(ie, it considers not lru
>> type granularity but zone )
>> But I think it can prevent unnecessary OOM problem and solve deadlock problem.
>
> Can you please elaborate your intention? Do you think Wu's approach is wrong?

No. I think Wu's patch may work well. But I agree Andrew.
Couldn't we remove the too_many_isolated logic? If it is, we can solve
the problem simply.
But If we remove the logic, we will meet long time ago problem, again.
So my patch's intention is to prevent OOM and deadlock problem with
simple patch without adding new heuristic in too_many_isolated.


-- 
Kind regards,
Minchan Kim
