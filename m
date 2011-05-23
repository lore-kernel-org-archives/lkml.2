Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1EWL21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:28:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab1EWL20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:28:26 -0400
Date: Mon, 23 May 2011 13:28:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Fix sample size bit operations
Message-ID: <20110523112815.GA4042@elte.hu>
References: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
 <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> What we want is to count the number of bits in the mask,
> not some other random operation written in the middle
> of the night.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 17c1c3c..d3fa7e4 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
>  	int i;
>  
>  	for (i = 0; i < 64; i++) {
> -		if ((mask << i) & 1)
> +		if (mask & (1 << i))
>  			size++;
>  	}

I fixed this to be 1UL and applied your fixes out of email - perf top and perf 
report works fine now, so this was a 64-bitness bug (you probably used a 32-bit 
system for testing?).

Btw., shouldnt this use hweight() or such?

Thanks,

	Ingo
