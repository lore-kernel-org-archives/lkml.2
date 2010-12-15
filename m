Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0LOQsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:48:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:60331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0LOQsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:48:35 -0500
Message-ID: <4D08F12A.3090107@kernel.org>
Date: Wed, 15 Dec 2010 17:47:38 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com> <20101214162855.392020353@linux.com>
In-Reply-To: <20101214162855.392020353@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:47:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> Use cmpxchg instead of xchg to realize this_cpu_xchg.
> 
> xchg will cause LOCK overhead since LOCK is always implied but cmpxchg
> will not.
> 
> Baselines:
> 
> xchg()		= 18 cycles (no segment prefix, LOCK semantics)
> __this_cpu_xchg = 1 cycle
> 
> (simulated using this_cpu_read/write, two prefixes. Looks like the
> cpu can use loop optimization to get rid of most of the overhead)
> 
> Cycles before:
> 
> this_cpu_xchg	 = 37 cycles (segment prefix and LOCK (implied by xchg))
> 
> After:
> 
> this_cpu_xchg	= 11 cycle (using cmpxchg without lock semantics)
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

It's not a bad idea to keep this patch separate from the original one
but as both are not applied yet, it probably is better to put this
right after the original addition if you end up re-posting the series;
otherwise, I'll just reorder it when I apply.

Thanks.

-- 
tejun
