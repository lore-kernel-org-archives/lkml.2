Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1CBIp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:45:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab1CBIp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:45:57 -0500
Date: Wed, 2 Mar 2011 09:45:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liu Yuan <namei.unix@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
Message-ID: <20110302084542.GA20795@elte.hu>
References: <no>
 <1299055090-23976-4-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299055090-23976-4-git-send-email-namei.unix@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liu Yuan <namei.unix@gmail.com> wrote:

> +		if (likely(!retry_find) && page && PageUptodate(page))
> +			page_cache_acct_hit(inode->i_sb, READ);
> +		else
> +			page_cache_acct_missed(inode->i_sb, READ);

Sigh.

This would make such a nice tracepoint or sw perf event. It could be collected in a 
'count' form, equivalent to the stats you are aiming for here, or it could even be 
traced, if someone is interested in such details.

It could be mixed with other events, enriching multiple apps at once.

But, instead of trying to improve those aspects of our existing instrumentation 
frameworks, mm/* is gradually growing its own special instrumentation hacks, missing 
the big picture and fragmenting the instrumentation space some more.

That trend is somewhat sad.

Thanks,

	Ingo
