Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0IJIzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:55:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:41212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0IJIzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:55:41 -0400
Subject: Re: [PATCH percpu#for-next] percpu: clear memory allocated with
 the km allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
In-Reply-To: <4C89F1CE.4050302@gmail.com>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	 <1284040322.2589.174.camel@edumazet-laptop>
	 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
	 <1284106566.402.26.camel@laptop> <4C89EF37.5080803@kernel.org>
	 <4C89F1CE.4050302@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 10:55:18 +0200
Message-ID: <1284108918.402.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 10:52 +0200, Tejun Heo wrote:
> Percpu allocator should clear memory before returning it but the km
> allocator forgot to do it.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Spotted-by: Peter Zijlstra <peterz@infradead.org>

(fwiw, -tip uses Reported-by)

Acked-by: Peter Zijlstra <peterz@infradead.org>

> ---
>  mm/percpu-km.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index 7037bc7..89633fe 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -35,7 +35,11 @@
> 
>  static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
>  {
> -	/* noop */
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
> +
>  	return 0;
>  }
> 


