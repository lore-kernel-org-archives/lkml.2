Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1EXJEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:04:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60529 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1EXJEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kXPGAsBh1iPCR4+bm11ZROCqigW+dxDy0HT8A/PpyEwqConF1f1C2F3nVIEELIS/Fx
         v4X8FDT1XFPw0VmppOWRxG/RGuhO2yXLCOe/o7Viai94fAMQWoBMW3fFy6/yfSQQpSRp
         VkB9s1wVYN+RaODmBrnOGkL+2Ahin5izPqvlM=
MIME-Version: 1.0
In-Reply-To: <4DDB711B.8010408@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6207E.1070300@jp.fujitsu.com>
	<BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
	<4DDB0FB2.9050300@jp.fujitsu.com>
	<BANLkTinKm=m8zdPGN0Trpy4HtEFyxMYzPA@mail.gmail.com>
	<4DDB711B.8010408@jp.fujitsu.com>
Date: Tue, 24 May 2011 18:04:19 +0900
Message-ID: <BANLkTik5tXv+k9tk2egXgmBRzcBD5Avjkw@mail.gmail.com>
Subject: Re: [PATCH 4/5] oom: don't kill random process
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 5:49 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> (2011/05/24 17:46), Minchan Kim wrote:
>> On Tue, May 24, 2011 at 10:53 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>>> +       /*
>>>>> +        * chosen_point==1 may be a sign that root privilege bonus is too
>>>>> large
>>>>> +        * and we choose wrong task. Let's recalculate oom score without
>>>>> the
>>>>> +        * dubious bonus.
>>>>> +        */
>>>>> +       if (protect_root&&  (chosen_points == 1)) {
>>>>> +               protect_root = 0;
>>>>> +               goto retry;
>>>>> +       }
>>>>
>>>> The idea is good to me.
>>>> But once we meet it, should we give up protecting root privileged
>>>> processes?
>>>> How about decaying bonus point?
>>>
>>> After applying my patch, unprivileged process never get score-1. (note,
>>> mapping
>>> anon pages naturally makes to increase nr_ptes)
>>
>> Hmm, If I understand your code correctly, unprivileged process can get
>> a score 1 by 3% bonus.
>
> 3% bonus is for privileged process. :)

OMG. Typo.
Anyway, my point is following as.
If chose_point is 1, it means root bonus is rather big. Right?
If is is, your patch does second loop with completely ignore of bonus
for root privileged process.
My point is that let's not ignore bonus completely. Instead of it,
let's recalculate 1.5% for example.

But I don't insist on my idea.
Thanks.
-- 
Kind regards,
Minchan Kim
