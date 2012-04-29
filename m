Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2D2I2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 04:28:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45177 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2D2I2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 04:28:43 -0400
Message-ID: <4F9CFBB4.2080708@openvz.org>
Date: Sun, 29 Apr 2012 12:28:36 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: [PATCH 1/2] proc: report file/anon bit in /proc/pid/pagemap
References: <4F91BC8A.9020503@parallels.com> <20120427123901.2132.47969.stgit@zurg> <CAHGf_=riWBO6-Ax0hfSU3hhxr7oXwLwtzJC55yeEpZDOjbqREg@mail.gmail.com>
In-Reply-To: <CAHGf_=riWBO6-Ax0hfSU3hhxr7oXwLwtzJC55yeEpZDOjbqREg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
>> index 4600cbe..7587493 100644
>> --- a/Documentation/vm/pagemap.txt
>> +++ b/Documentation/vm/pagemap.txt
>> @@ -16,7 +16,7 @@ There are three components to pagemap:
>>      * Bits 0-4   swap type if swapped
>>      * Bits 5-54  swap offset if swapped
>>      * Bits 55-60 page shift (page size = 1<<page shift)
>> -    * Bit  61    reserved for future use
>> +    * Bit  61    page is file-page or shared-anon
>>      * Bit  62    page swapped
>>      * Bit  63    page present
>
> hmm..
> Here says, file or shmem.
>
>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 2d60492..bc3df31 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -700,6 +700,7 @@ struct pagemapread {
>>
>>   #define PM_PRESENT          PM_STATUS(4LL)
>>   #define PM_SWAP             PM_STATUS(2LL)
>> +#define PM_FILE             PM_STATUS(1LL)
>>   #define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
>>   #define PM_END_OF_BUFFER    1
>
> But, this macro says it's file. it seems a bit misleading. ;-)

well... you know, shmem/shared-anon actually lays on tmpfs. so they really file-pages.

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=ilto:"dont@kvack.org">  email@kvack.org</a>

