Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669Ab2ERKCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:02:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:54236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762577Ab2ERKCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:02:11 -0400
Message-ID: <1337335323.573.7.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 12:02:03 +0200
In-Reply-To: <1332340496-21658-2-git-send-email-bp@amd64.org>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a barebones implementation for registering persistent events with
> perf. For that, we don't destroy the buffers when they're unmapped;
> also, we map them read-only so that multiple agents can access them.

> +static struct perf_event *perf_add_persistent(struct perf_event_attr *attr,
> +					      int cpu, unsigned nr_pages)
> +{
> +	struct ring_buffer *buffer;
> +	struct perf_event *event;
> +
> +	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
> +	if (IS_ERR(event))
> +		return event;
> +
> +	buffer = rb_alloc(nr_pages, 0, cpu, RING_BUFFER_WRITABLE);

Uh what?
