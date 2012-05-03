Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab2ECVU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2ECVUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:20:53 -0400
Message-ID: <4FA2EA4A.6040703@redhat.com>
Date: Thu, 03 May 2012 16:27:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
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
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com> <4FA2C946.60006@redhat.com>
In-Reply-To: <4FA2C946.60006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 02:07 PM, Rik van Riel wrote:
> On 05/03/2012 01:34 PM, rajman mekaco wrote:
>> The user_shm_lock and user_shm_unlock functions use a single global
>> spinlock for protecting the user->locked_shm.
>>
>> This is an overhead for multiple CPUs calling this code even if they
>> are having different user_struct.
>>
>> Remove the global shmlock_user_lock and introduce and use a new
>> spinlock inside of the user_struct structure.
>>
>> Signed-off-by: rajman mekaco<rajman.mekaco@gmail.com>
>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Hold this ... while the patch is correct, Peter raised
a valid concern about its usefulness, which should be
sorted out first.

