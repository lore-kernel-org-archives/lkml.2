Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2DJA3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:29:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62249 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2DJA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:29:29 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-86-4f837ee6fbbd
Message-ID: <4F837F6E.3010508@kernel.org>
Date: Tue, 10 Apr 2012 09:31:42 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Alexey Ivanov <rbtz@yandex-team.ru>
CC: Rik van Riel <riel@redhat.com>,
        "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, yinghan@google.com
Subject: Re: mapped pagecache pages vs unmapped pages
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com> <12701333991475@webcorp7.yandex-team.ru> <4F8326FD.8020507@redhat.com> <8041334015453@webcorp4.yandex-team.ru>
In-Reply-To: <8041334015453@webcorp4.yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-10 오전 8:50, Alexey Ivanov 쓴 글:

> Did you consider making this ratio tunable, at least manually(i.e. via sysctl)?
> I suppose we are not the only ones with almost-whole-ram-mmaped workload.


Personally, I think it's not good approach.
It depends on kernel's internal implemenatation which would be changed
in future as we chagend it at 2.6.28.

In my opinion, kernel just should do best effort to keep active working
set except some critical pages which are code pages. If it's not active
working set but user want to keep them, we have to add new feature like
fadvise/madvise(WORKING_SET) to give the hint to kenrel. Although it
causes changing legacy programs, it doesn't copuled kernel's reclaim
algorithm and it's way to go, I think.

> 
> 09.04.2012, 22:56, "Rik van Riel" <riel@redhat.com>:
>> On 04/09/2012 01:11 PM, Alexey Ivanov wrote:
>>
>>>  Thanks for the hint!
>>>
>>>  Can anyone clarify the reason of not using zone->inactive_ratio in inactive_file_is_low_global()?
>>
>> New anonymous pages start out on the active anon list, and
>> are always referenced.  If memory fills up, they may end
>> up getting moved to the inactive anon list; being referenced
>> while on the inactive anon list is enough to get them promoted
>> back to the active list.
>>
>> New file pages start out on the INACTIVE file list, and
>> start their lives not referenced at all. Due to readahead
>> extra reads, many file pages may never be referenced.
>>
>> Only file pages that are referenced twice make it onto
>> the active list.
>>
>> This means the inactive file list has to be large enough
>> for all the readahead buffers, and give pages enough time
>> on the list that frequently accessed ones can get accessed
>> twice and promoted.
>>
>> http://linux-mm.org/PageReplacementDesign
>>
>> --
>> All rights reversed
> 



-- 
Kind regards,
Minchan Kim
