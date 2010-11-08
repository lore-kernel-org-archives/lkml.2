Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0KHQmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:42:47 -0500
Received: from www.tglx.de ([62.245.132.106]:41169 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0KHQmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:42:45 -0500
Date: Mon, 8 Nov 2010 17:42:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com,
        jkacur@redhat.com, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 3/3] futex: add futex_q static initializer
In-Reply-To: <1288216466-14309-4-git-send-email-dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011081724460.2900@localhost6.localdomain6>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com> <1288216466-14309-4-git-send-email-dvhart@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Darren Hart wrote:

> The futex_q struct has grown considerably over the last couple years. I
> believe it now merits a static initializer to avoid uninitialized data
> errors (having spent more time than I care to admit debugging an uninitialized
> q.bitset in an experimental new op code).
> 
> With the key initializer built in, several of the FUTEX_KEY_INIT calls can
> be removed.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---
>  kernel/futex.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 8502498..4a10d44 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -131,6 +131,12 @@ struct futex_q {
>  	u32 bitset;
>  };
>  
> +#define FUTEX_Q_INIT \
> +	{ /* list gets initialized in queue_me()*/ \
> +	  .task = NULL, NULL, FUTEX_KEY_INIT \
> +	, NULL, NULL, NULL, FUTEX_BITSET_MATCH_ANY }
> +

That should be a static readonly variable with a proper C99
initializer. 

Thanks,

	tglx
