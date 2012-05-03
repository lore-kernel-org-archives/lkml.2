Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab2ECU1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2ECU1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:27:04 -0400
Message-ID: <4FA2EA08.9030109@redhat.com>
Date: Thu, 03 May 2012 16:26:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rajman mekaco <rajman.mekaco@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mlock: split the shmlock_user_lock spinlock into
 per user_struct spinlock
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com> <1336073474.6509.2.camel@twins>
In-Reply-To: <1336073474.6509.2.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 03:31 PM, Peter Zijlstra wrote:
> On Thu, 2012-05-03 at 23:04 +0530, rajman mekaco wrote:
>> The user_shm_lock and user_shm_unlock functions use a single global
>> spinlock for protecting the user->locked_shm.
>
> Are you very sure its only protecting user state? This changelog doesn't
> convince me you've gone through everything and found it good.
>
>> This is an overhead for multiple CPUs calling this code even if they
>> are having different user_struct.
>>
>> Remove the global shmlock_user_lock and introduce and use a new
>> spinlock inside of the user_struct structure.
>
> While I don't immediately see anything wrong with it, I doubt its
> useful. What workload run with enough users that this makes a difference
> one way or another?

When running with containers and/or LXC, I believe that
each UID in each container gets its own user_struct, but
you do raise a good question - what user programs call
mlock anyway, and how often?
