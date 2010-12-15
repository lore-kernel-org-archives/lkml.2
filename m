Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0LORc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:32:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab0LORc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:32:58 -0500
Message-ID: <4D08FB62.9070104@zytor.com>
Date: Wed, 15 Dec 2010 09:31:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
References: <20101214162842.542421046@linux.com>	 <20101214162854.218751478@linux.com>  <4D08EDA9.3090801@kernel.org>	 <1292431839.2708.30.camel@laptop>	 <alpine.DEB.2.00.1012151059430.13049@router.home> <1292433517.2708.41.camel@laptop>
In-Reply-To: <1292433517.2708.41.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 09:18 AM, Peter Zijlstra wrote:
> On Wed, 2010-12-15 at 11:04 -0600, Christoph Lameter wrote:
> 
>> Prefixes are faster than explicit address calculations. A prefix allows
>> you to integrate the per cpu address calculation into an arithmetic
>> operation.
> 
> Well, depends on how often you need that address I'd think. If you'd
> have a per-cpu struct and need to frob lots of variables in that struct
> it might be cheaper to simply compute the struct address once and then
> use relative addresses than to prefix everything with %fs.
> 

Let's just make it clear -- current x86 CPUs generally do not have a
penalty for prefixes (it might be that under very unusual pipeline
conditions they do, I am not 100% sure.)  In fact, we changed patching
LOCK prefixes from NOP to %ds: because it made the code faster.

Some older CPUs do, but those are no longer relevant for performance
decisions.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

