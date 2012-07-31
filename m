Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2GaV41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2GaV4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:56:24 -0400
Message-ID: <5018547B.4020000@redhat.com>
Date: Tue, 31 Jul 2012 17:56:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] sched, numa: Per task memory placement for big
 processes
References: <20120731191204.540691987@chello.nl> <20120731192809.428855038@chello.nl>
In-Reply-To: <20120731192809.428855038@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:12 PM, Peter Zijlstra wrote:
> Probability says that the task faulting on a page after we protect it,
> is most likely to be the task that uses that page most.
>
> To decrease the likelyhood of acting on a false relation, we only
> migrate a page when two consecutive samples are from the same task.
>
> I'm still not entirely convinced this scheme is sound, esp. for things
> like virtualization and n:m threading solutions in general the
> compute<->task relation is fundamentally untrue.

Again, we may need some additional code on top in the future,
eg. something like Andrea's policy that tries grouping related
tasks/threads together, but this looks like a very good way
to start.

We can introduce complexity if it is needed. Simplicity is good.

Acked-by: Rik van Riel

-- 
All rights reversed
