Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2JWNOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:14:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2JWNOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:14:08 -0400
Message-ID: <1350998032.13456.25.camel@twins>
Subject: Re: [PATCH 15/34] perf, core: Add a concept of a weightened sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 15:13:52 +0200
In-Reply-To: <1350602382-12771-16-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-16-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> @@ -601,6 +602,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>         data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
>         data->regs_user.regs = NULL;
>         data->stack_user_size = 0;
> +       data->weight = 0;
>  }
>  
>  extern void perf_output_sample(struct perf_output_handle *handle,

> @@ -562,6 +565,7 @@ enum perf_event_type {
>          *      { u64                   stream_id;} && PERF_SAMPLE_STREAM_ID
>          *      { u32                   cpu, res; } && PERF_SAMPLE_CPU
>          *      { u64                   period;   } && PERF_SAMPLE_PERIOD
> +        *      { u64                   weight;   } && PERF_SAMPLE_WEIGHT
>          *
>          *      { struct read_format    values;   } && PERF_SAMPLE_READ
>          * 

So the only issues I have are that his makes every sample more expensive
by having to 0 out that weight data and the sample placement.

I don't think avoiding that weight init is really worth the pain that'll
cause, so we'll just leave it there.

As to the placement, I suppose it makes sense, although Stephane once
complained about these fields not being in PERF_SAMPLE numeric order.
Since we're not that anyway, he'll have to deal with it.. Stephane, any
strong arguments against this placement?

Also, Stephane, you said you had something similar in you LL patches, do
you mean to re-use this or should we re-base this on top of your
patches.. ?
