Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1ERFov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:44:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39158 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1ERFot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q1MF4TTrHOiePryDAmdkUYfATbH8X+QZY3/L1oC4l7UbXr9i+fBYmw2tViZOAgFsB7
         u5CeoSUq5MvuiRT1n6gx2YxCzfNoMxixRRb5z9fdiQKmLYeUOHMAIXvG61cDiH6Kqpb3
         CQT4dGG455u6tFz7HcGMLRb7J8Wvzipdsvq7c=
MIME-Version: 1.0
In-Reply-To: <4DD31B6E.8040502@jp.fujitsu.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
	<1305295404-12129-5-git-send-email-mgorman@suse.de>
	<4DCFAA80.7040109@jp.fujitsu.com>
	<1305519711.4806.7.camel@mulgrave.site>
	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
	<20110516084558.GE5279@suse.de>
	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
	<20110516102753.GF5279@suse.de>
	<BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
	<4DD31B6E.8040502@jp.fujitsu.com>
Date: Wed, 18 May 2011 14:44:48 +0900
Message-ID: <BANLkTikLuWPEt7MitUYdJtzqyBSOkz2zxg@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mgorman@suse.de, James.Bottomley@hansenpartnership.com,
        akpm@linux-foundation.org, colin.king@canonical.com,
        raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
        cl@linux.com, penberg@kernel.org, riel@redhat.com, hannes@cmpxchg.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:05 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> It would be better to put cond_resched after balance_pgdat?
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 292582c..61c45d0 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2753,6 +2753,7 @@ static int kswapd(void *p)
>>                 if (!ret) {
>>                         trace_mm_vmscan_kswapd_wake(pgdat->node_id,
>> order);
>>                         order = balance_pgdat(pgdat,
>> order,&classzone_idx);
>> +                       cond_resched();
>>                 }
>>         }
>>         return 0;
>>
>>>>> While it appears unlikely, there are bad conditions which can result
>>>
>>> in cond_resched() being avoided.
>
> Every reclaim priority decreasing or every shrink_zone() calling makes more
> fine grained preemption. I think.

It could be.
But in direct reclaim case, I have a concern about losing pages
reclaimed to other tasks by preemption.

Hmm,, anyway, we also needs test.
Hmm,, how long should we bother them(Colins and James)?
First of all, Let's fix one just between us and ask test to them and
send the last patch to akpm.

1. shrink_slab
2. right after balance_pgdat
3. shrink_zone
4. reclaim priority decreasing routine.

Now, I vote 1) and 2).

Mel, KOSAKI?
-- 
Kind regards,
Minchan Kim
