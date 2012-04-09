Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab2DISYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:24:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59486 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2DISX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <12701333991475@webcorp7.yandex-team.ru>
References: <37371333672160@webcorp7.yandex-team.ru>
	<4F7E9854.1020904@gmail.com>
	<12701333991475@webcorp7.yandex-team.ru>
Date: Mon, 9 Apr 2012 11:17:35 -0700
Message-ID: <CALWz4ixcXXPU_=vqcsH1uLkG8jsL+4yP0oLhhHvnNdMa6pzZQw@mail.gmail.com>
Subject: Re: mapped pagecache pages vs unmapped pages
From: Ying Han <yinghan@google.com>
To: Alexey Ivanov <rbtz@yandex-team.ru>
Cc: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 10:11 AM, Alexey Ivanov <rbtz@yandex-team.ru> wrote:
> Thanks for the hint!
>
> Can anyone clarify the reason of not using zone->inactive_ratio in inactive_file_is_low_global()?

anonymous pages starts out referenced in active list, and scanning the
whole active list will only rotate those pages. So we would like to
limit the size of inactive anon to save scanning.

--Ying


>
> 06.04.2012, 11:16, "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>:
>> On 04/06/2012 08:29 AM, Alexey Ivanov wrote:
>>
>>>  In progress of migration from FreeBSD to Linux and we found some strange behavior: periodically running tasks (like rsync/p2p deployment) evict mapped pages from memory.
>>>
>>>  From my little research I've found following lkml thread:
>>>  https://lkml.org/lkml/2008/6/11/278
>>>  And more precisely this commit: https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f98a2fee8acdb4ac84545df98cccecfd130f8db
>>>  which along with splitting LRU into "anon" and "file" removed support of reclaim_mapped.
>>>
>>>  Is there a knob to prioritize mapped memory over unmapped (without modifying all apps to use O_DIRECT/fadvise/madvise or mlocking our data in memory) or at least some way to change proportion of Active(file)/Inactive(file)?
>>
>> Hi Alexey,
>>
>> Cc to linux-mm mailing list.
>>
>> I have met the similar problem and I have sent a mail to discuss it.
>> Maybe it can help you
>> (http://marc.info/?l=linux-mm&m=132947026019538&w=2).
>>
>> Now Konstantin has sent a patch set to try to expand vm_flags from 32
>> bit to 64 bit.  Then we can add the new flag into vm_flags and
>> prioritize mmaped pages in madvise(2).
>>
>> Regards,
>> Zheng
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Alexey Ivanov
> Yandex Search Admin Team
> *************
> tel.: +7 (985) 120-35-83 (int. 7176)
> http://staff.yandex-team.ru/rbtz
> *************
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
