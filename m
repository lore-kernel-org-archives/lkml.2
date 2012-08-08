Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2HHSpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822Ab2HHSpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:45:33 -0400
Message-ID: <5022B356.9060902@redhat.com>
Date: Wed, 08 Aug 2012 14:43:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org, oleg@redhat.com,
        pjt@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] sched-numa rewrite
References: <20120731191204.540691987@chello.nl> <20120808171714.GM10459@redhat.com>
In-Reply-To: <20120808171714.GM10459@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 01:17 PM, Andrea Arcangeli wrote:
> Hi everyone,
>
> On Tue, Jul 31, 2012 at 09:12:04PM +0200, Peter Zijlstra wrote:
>> Hi all,
>>
>> After having had a talk with Rik about all this NUMA nonsense where he proposed
>> the scheme implemented in the next to last patch, I came up with a related
>> means of doing the home-node selection.
>>
>> I've also switched to (ab)using PROT_NONE for driving the migration faults.
>
> I'm glad we agree on the introduction of the numa hinting page faults.
>
> I run a benchmark to compare your sched-numa rewrite with autonuma22:
>
> http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/autonuma-vs-sched-numa-rewrite-20120808.pdf

For the people who have not yet read that PDF:

While the sched-numa code is relatively small and clean, the
current version does not seem to offer a significant
performance improvement over not having it, and in one of
the tests performance actually regresses vs. mainline.

On the other hand, the autonuma code is pretty large and
hard to understand, but it does provide a significant
speedup on each of the tests.

I have not looked at why sched-numa is not giving a significant
performance improvement.
