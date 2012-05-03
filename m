Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2ECIOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:14:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59444 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2ECIOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:14:03 -0400
X-AuditID: 9c93016f-b7c79ae0000006b3-9a-4fa23e482141
Message-ID: <4FA23E47.6040303@kernel.org>
Date: Thu, 03 May 2012 17:13:59 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Pekka Enberg <penberg@kernel.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Subject: Re: vmevent: question?
References: <4F9E39F1.5030600@kernel.org> <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com> <4F9E44AD.8020701@kernel.org> <CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com> <4F9E4F0A.8030900@kernel.org> <alpine.LFD.2.02.1205031019410.3686@tux.localdomain> <4FA23A83.4040604@kernel.org> <CAOJsxLHxLbzp+nfc72pzzyAe8W5w-phbHhREdJ7Mg5P9JHeF5A@mail.gmail.com>
In-Reply-To: <CAOJsxLHxLbzp+nfc72pzzyAe8W5w-phbHhREdJ7Mg5P9JHeF5A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:07 PM, Pekka Enberg wrote:

> On Thu, May 3, 2012 at 10:57 AM, Minchan Kim <minchan@kernel.org> wrote:
>> Sorry for my poor explanation.
>> My point is when userspace get vmevent_event by reading fd, it could enumerate
>> several attribute all at once.
>> Then, one of attribute(call A) made by vmevent_match in kernel and other attributes(call B, C, D)
>> are just extra for convenience. Because there is time gap when kernel get attribute values, B,C,D could be stale.
>> Then, how can user determine which event is really triggered? A or B or C or D?
>> Which event really happens?
> 
> Right. Mark the matching values with something like
> VMEVENT_ATTR_STATE_CAPTURED should be sufficient?


Seems to be good and we have to notice to user by document
"Except VMEVENT_ATTR_STATE_CAPTURED, all attributes's value could be stale.
So, don't be deceived. Please ignore if you need"

First of all, let make CAPTURED state could be exact.

-----
> Q 2. Is it okay although value when vmevent_match check happens is different with
>     vmevent_sample_attr in vmevent_sample's for loop?
>     I think it's not good.
Yeah, that's just silly and needs fixing.
-----

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
