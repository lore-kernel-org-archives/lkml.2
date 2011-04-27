Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1D0Bh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:37:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41664 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1D0Bh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QYBN0teYrvEJxJaMpRltq1UvJlEnB47/aT2QT0OdgJp2eb7i80KnPalyW8CWx0/Mov
         Oal1/ZUi4GgiRPPmZPDnB7oxi/DqLkzkhzCEo6qVppk9ISKF1/7SvWa2dw+lU2GmHlva
         QNQPxuj9QAwSyRc87Vknq5cH7ZkfskqqqQs8w=
MIME-Version: 1.0
In-Reply-To: <BANLkTim067_+bycA-rJk6u595YucMmruqQ@mail.gmail.com>
References: <20110426085953.GA12389@darkstar>
	<BANLkTikkUq7rg4umYQ5yt9ve+q34Pf+=Ag@mail.gmail.com>
	<BANLkTin0wj3AhCtR5ZD=N_LUKjE1etBcFg@mail.gmail.com>
	<BANLkTim067_+bycA-rJk6u595YucMmruqQ@mail.gmail.com>
Date: Wed, 27 Apr 2011 09:37:57 +0800
Message-ID: <BANLkTi=8ySUPP6_GUL9CTFh98J1PH0a4=g@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_balloon: disable oom killer when fill balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 7:33 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 6:39 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> On Tue, Apr 26, 2011 at 5:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>> Please resend this with [2/2] to linux-mm.
>>>
>>> On Tue, Apr 26, 2011 at 5:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>>> When memory pressure is high, virtio ballooning will probably cause oom killing.
>>>> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
>>>> will make memory becoming low then memory alloc of other processes will trigger
>>>> oom killing. It is not desired behaviour.
>>>
>>> I can't understand why it is undesirable.
>>> Why do we have to handle it specially?
>>>
>>
>> Suppose user run some random memory hogging process while ballooning
>> it will be undesirable.
>
>
> In VM POV, kvm and random memory hogging processes are customers.
> If we handle ballooning specially with disable OOM, what happens other
> processes requires memory at same time? Should they wait for balloon
> driver to release memory?
>
> I don't know your point. Sorry.
> Could you explain your scenario in detail for justify your idea?

What you said make sense I understand what you said now. Lets ignore
my above argue and see what I'm actually doing.

I'm hacking with balloon driver to fit to short the vm migration time.

while migrating host tell guest to balloon as much memory as it can, then start
migrate, just skip the ballooned pages, after migration done tell
guest to release the memory.

In migration case oom is not I want to see and disable oom will be good.

> And as I previous said, we have to solve oom_killer_disabled issue in
> do_try_to_free_pages.
>
> Thanks, Dave.
> --
> Kind regards,
> Minchan Kim
>



-- 
Regards
dave
