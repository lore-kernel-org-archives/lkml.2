Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1FMKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:09:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1FMKJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:09:28 -0400
Date: Mon, 13 Jun 2011 12:09:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Subject: Re: [PATCH 02/15] tracing: Use NUMA allocation for per-cpu ring
 buffer pages
Message-ID: <20110613100918.GB30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
 <20110609172910.665010533@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609172910.665010533@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

>  	for (i = 0; i < nr_pages; i++) {
> +		struct page *page;
>  		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),

missing separation between local variable definitions and the first C 
statement.

Same mistake repeats elsewhere in the patch as well.

> +			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL,
> +						0);

that linebreak is pointless.

> +		info->spare = ring_buffer_alloc_read_page(info->tr->buffer,
> +								info->cpu);

ditto.

Thanks,

	Ingo
