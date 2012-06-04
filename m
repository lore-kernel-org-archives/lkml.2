Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2FDIoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:44:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46228 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2FDIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:44:53 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-36-4fcc75825ea9
Message-ID: <4FCC7592.9030403@kernel.org>
Date: Mon, 04 Jun 2012 17:45:06 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Pekka Enberg <penberg@kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
References: <20120504073810.GA25175@lizard> <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com> <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com> <20120507121527.GA19526@lizard> <4FA82056.2070706@gmail.com> <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com> <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com> <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com> <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com> <CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com> <20120601122118.GA6128@lizard> <alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 03:26 AM, Pekka Enberg wrote:

> On Fri, 1 Jun 2012, Anton Vorontsov wrote:
>>> That's pretty awful. Anton, Leonid, comments?
>> [...]
>>>> 5) __VMEVENT_ATTR_STATE_VALUE_WAS_LT should be removed from userland
>>>> exporting files.
>>>>  When exporing kenrel internal, always silly gus used them and made unhappy.
>>>
>>> Agreed. Anton, care to cook up a patch to do that?
>>
>> KOSAKI-San, Pekka,
>>
>> Much thanks for your reviews!
>>
>> These three issues should be fixed by the following patches. One mm/
>> change is needed outside of vmevent...
>>
>> And I'm looking into other issues you pointed out...
> 
> I applied patches 2, 4, and 5. The vmstat patch need ACKs from VM folks 
> to enter the tree.
> 
> 			Pekka


It's time to wrap it up.
It seems some people include me have tried to improve vmevent
But I hope let us convince why we need vmevent before further review/patch.

Recently I tried reclaim-latency based notifier to consider backed device speed I mentioned elsewhere thread.
The working model is that measure reclaim time and if it doesn't finish requirement time which is configurable
by admin, notify it to user or kill some thread but I didn't published yet because it's not easy for admin to control
and several issues.

AFAIK, low memory notifier is started for replacing android lowmemory killer.
At the same time, other folks want use it generally.
As I look through android low memory killer, it's not too bad except some point.

1. It should not depend on shrink_slab. If we need, we can add some hook in vmscan.c directly instead of shrink_slab.
2. We can use out_of_memory instead of custom victim selection/killing function. If we need,
   we can change out_of_memory interface little bit for passing needed information to select victim.
3. calculation for available pages

1) and 2) would make android low memory killer very general and 3) can meet each folk's requirement, I believe.

Anton, I expect you already investigated android low memory killer so maybe you know pros and cons of each solution.
Could you convince us "why we need vmevent" and "why can't android LMK do it?"

KOSAKI, AFAIRC, you are a person who hates android low memory killer.
Why do you hate it? If it solve problems I mentioned, do you have a concern, still?
If so, please, list up.

Android low memory killer is proved solution for a long time, at least embedded area(So many android phone already have used it) so I think improving it makes sense to me rather than inventing new wheel.
Frankly speaking, I don't know vmevent's other use cases except low memory notification and didn't see
any agreement about that with other guys.

I hope we get an agreement about vmevent before further enhance.

Thanks, all.

-- 
Kind regards,
Minchan Kim
