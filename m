Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1FML2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1FML2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:28:48 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=ikRMZXrKoDMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=lIXPK7z8ijYRLzz7eyEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 02/15] tracing: Use NUMA allocation for per-cpu ring
 buffer pages
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <20110613100918.GB30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172910.665010533@goodmis.org>  <20110613100918.GB30962@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:28:46 -0400
Message-ID: <1307964526.9218.49.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:09 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  	for (i = 0; i < nr_pages; i++) {
> > +		struct page *page;
> >  		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
> 
> missing separation between local variable definitions and the first C 
> statement.
> 
> Same mistake repeats elsewhere in the patch as well.
> 
> > +			page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL,
> > +						0);
> 
> that linebreak is pointless.

Probably to keep the 80 char limit :-p


> 
> > +		info->spare = ring_buffer_alloc_read_page(info->tr->buffer,
> > +								info->cpu);
> 
> ditto.

I can fix these up.

-- Steve


