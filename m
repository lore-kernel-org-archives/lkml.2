Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0LOQdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:33:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:33878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0LOQdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:33:18 -0500
Message-ID: <4D08EDA9.3090801@kernel.org>
Date: Wed, 15 Dec 2010 17:32:41 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
References: <20101214162842.542421046@linux.com> <20101214162854.218751478@linux.com>
In-Reply-To: <20101214162854.218751478@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:32:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> The irq work queue is a per cpu object and it is sufficient for
> synchronization if per cpu atomics are used. Doing so simplifies
> the code and reduces the overhead of the code.
> 
> Before:
> 
> christoph@linux-2.6$ size kernel/irq_work.o
>    text	   data	    bss	    dec	    hex	filename
>     451	      8	      1	    460	    1cc	kernel/irq_work.o
> 
> After:
> 
> christoph@linux-2.6$ size kernel/irq_work.o 
>    text	   data	    bss	    dec	    hex	filename
>     438	      8	      1	    447	    1bf	kernel/irq_work.o
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Peter, can you please ack this one?

Thanks.

-- 
tejun
