Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2EJWa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:30:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab2EJWa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:30:57 -0400
Message-ID: <4FAC418E.6060500@redhat.com>
Date: Thu, 10 May 2012 18:30:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: rajman mekaco <rajman.mekaco@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mlock: split the shmlock_user_lock spinlock into
 per user_struct spinlock
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com> <4FA2C946.60006@redhat.com> <4FA2EA4A.6040703@redhat.com> <CAMYGaxosaVXmpQQqpq+bGV9F7-i8APTpDq=ErWdhw2EHGEzmKg@mail.gmail.com> <CAMYGaxruZbhvtZg76_zo6-BjChObpCAE8-MTA=xbBOavct+XNw@mail.gmail.com> <4FABD6BE.1060401@redhat.com> <CAMYGaxqxb=XR8R26h4e2URA2hG2M3j9V4u0DLJ9ifmkZKJa+eg@mail.gmail.com>
In-Reply-To: <CAMYGaxqxb=XR8R26h4e2URA2hG2M3j9V4u0DLJ9ifmkZKJa+eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 11:39 AM, rajman mekaco wrote:
> On Thu, May 10, 2012 at 8:24 PM, Rik van Riel<riel@redhat.com>  wrote:
>> On 05/10/2012 09:34 AM, rajman mekaco wrote:
>>
>>> Any updates on this ?
>>
>>
>> There is still no usecase to demonstrate a problem, so no real
>> justification to merge the patch.  Coming up with such a usecase
>> is up to the submitter of the patch.
>
> Maybe you didn't read my last email:
> If 2 different user-mode processes executing on 2 CPUs under 2 different
> users want to access the same shared memory through the
> shmctl(SHM_LOCK) / shmget(SHM_HUGETLB) / usr_shm_lock
> primitives, they could compete/spin even though their user_structs
> are different.
>
> Can you please correct me if I am missing some crucial point of understanding ?

Mlock is a very very expensive operation.

Updating the mlock statistics is a very cheap operation.

Does this spinlock ever show up contention wise?

-- 
All rights reversed
