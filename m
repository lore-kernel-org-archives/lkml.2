Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2KPSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab2KPSGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:06:34 -0500
Message-ID: <50A68096.1050208@redhat.com>
Date: Fri, 16 Nov 2012 13:06:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] sched, numa, mm: Add adaptive NUMA affinity support
References: <20121112160451.189715188@chello.nl> <20121112161215.782018877@chello.nl>
In-Reply-To: <20121112161215.782018877@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 11:04 AM, Peter Zijlstra wrote:

> We change the load-balancer to prefer moving tasks in order of:
>
>    1) !numa tasks and numa tasks in the direction of more faults
>    2) allow !ideal tasks getting worse in the direction of faults
>    3) allow private tasks to get worse
>    4) allow shared tasks to get worse
>
> This order ensures we prefer increasing memory locality but when
> we do have to make hard decisions we prefer spreading private
> over shared, because spreading shared tasks significantly
> increases the interconnect bandwidth since not all memory can
> follow.

Combined with the fact that we only turn a certain amount
of memory into NUMA ptes each second, could this result in
a program being classified as a private task one second,
and a shared task a few seconds later?

What does the code do to prevent such an oscillating of
task classification? (which would have consequences for
the way the task's NUMA placement is handled, and might
result in the task moving from node to node needlessly)

-- 
All rights reversed
