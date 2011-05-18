Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab1ERS0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:26:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58720 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab1ERS0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:26:10 -0400
Date: Wed, 18 May 2011 20:26:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v2 3/3] sched: increase SCHED_LOAD_SCALE resolution
Message-ID: <20110518182605.GC25881@elte.hu>
References: <1305738580-9924-1-git-send-email-ncrao@google.com>
 <1305738580-9924-4-git-send-email-ncrao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305738580-9924-4-git-send-email-ncrao@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikhil Rao <ncrao@google.com> wrote:

>  /*
> - * Increase resolution of nice-level calculations:
> + * Increase resolution of nice-level calculations for 64-bit architectures.
>   */
> -#define SCHED_LOAD_SHIFT	10
> +#if BITS_PER_LONG > 32
> +#define SCHED_LOAD_RESOLUTION	10
> +#define scale_load(w)		(w << SCHED_LOAD_RESOLUTION)
> +#define scale_load_down(w)	(w >> SCHED_LOAD_RESOLUTION)
> +#else
> +#define SCHED_LOAD_RESOLUTION	0
> +#define scale_load(w)		w
> +#define scale_load_down(w)	w
> +#endif

Please also be a bit more verbose in the comment above why we treat 64-bit 
architectures differently - it's not obvious.

Thanks,

	Ingo
