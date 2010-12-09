Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0LIG3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:29:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0LIG3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:29:34 -0500
Message-ID: <4D0076B3.9090106@zytor.com>
Date: Wed, 08 Dec 2010 22:26:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and	this_cpu_xchg
 operations
References: <20101208175520.456864019@linux.com> <20101208175543.000201149@linux.com> <alpine.DEB.2.00.1012081207250.26943@router.home> <20101208181736.GC30693@Krystal>
In-Reply-To: <20101208181736.GC30693@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 10:17 AM, Mathieu Desnoyers wrote:
> 
> Hi Christoph,
> 
> Can you show if this provides savings in terms of:
> 
> - instruction cache footprint
> - cycles required to run
> - large-scale impact on the branch prediction buffers
> 
> Given that this targets per-cpu data only, the additional impact on cache-line
> exchange traffic of using cmpxchg over xchg (cache-line not grabbed as exclusive
> by the initial read) should not really matter.
> 
> I'm CCing Arjan and HPA, because they might have some interesting insight into
> the performance impact of lock-prefixed xchg vs using local cmpxchg in a loop.
> 

XCHG is always locked; it doesn't need the prefix.  Unfortunately,
unlike on the 8086 on modern processors locks have a real cost.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

