Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2E3VZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:25:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2E3VZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:25:13 -0400
Message-ID: <4FC69035.3000509@gmail.com>
Date: Wed, 30 May 2012 17:25:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org> <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org> <alpine.DEB.2.00.1205301441350.31768@router.home> <20120530195244.GX27374@one.firstfloor.org> <CAHGf_=rS6cGjcJ7tKH05cMMdJKEO9f60mNBa0VaCkzs=kVjCQQ@mail.gmail.com> <20120530212235.GB20051@decadent.org.uk>
In-Reply-To: <20120530212235.GB20051@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 5:22 PM), Ben Hutchings wrote:
> On Wed, May 30, 2012 at 04:00:55PM -0400, KOSAKI Motohiro wrote:
>> On Wed, May 30, 2012 at 3:52 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>>> On Wed, May 30, 2012 at 02:42:42PM -0500, Christoph Lameter wrote:
>>>> On Wed, 30 May 2012, Andi Kleen wrote:
>>>>
>>>>> On Wed, May 30, 2012 at 01:50:02PM -0500, Christoph Lameter wrote:
>>>>>> On Wed, 30 May 2012, Andi Kleen wrote:
>>>>>>
>>>>>>> I always regretted that cpusets were no done with custom node lists.
>>>>>>> That would have been much cleaner and also likely faster than what we have.
>>>>>>
>>>>>> Could shared memory policies ignore cpuset constraints?
>>>>>
>>>>> Only if noone uses cpusets as a "security" mechanism, just for a "soft policy"
>>>>> Even with soft policy you could well break someone's setup.
>>>>
>>>> Well at least lets exempt shared memory from memory migration and memory
>>>> policy updates. That seems to be causing many of these issues.
>>>
>>> Migration on the page level is needed for the memory error handling.
>>>
>>> Updates: you mean not allowing to set the policy when there are already
>>> multiple mappers? I could see that causing some unexpected behaviour. Presumably
>>> a standard database will only set it at the beginning, but I don't know
>>> if that would work for all users.
>>
>> We don't need to kill migration core. We only need to kill that mbind(2) updates
>> vma->policy of shmem.
> [...]
>
> So should I (and Greg) drop 'mm: mempolicy: Let vma_merge and
> vma_split handle vma->vm_policy linkages' from the pending stable
> releases?  Or is that OK as an interim fix until these changes go
> into mainline?

Please drop. It screw up mbind(2).




