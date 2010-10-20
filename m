Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0JTNFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:56202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0JTNFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:05:14 -0400
Subject: Re: [PATCH] perf_events: fix time tracking in samples
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <AANLkTimtD249SMg3DeyOX3BFpHCtZeq8cU-2g_m-5GKV@mail.gmail.com>
References: <4cbdcbea.8491d80a.25b0.ffffece8@mx.google.com>
	 <1287507178.1998.3440.camel@laptop>
	 <AANLkTik5_h1hVfX=1chezE6z25r4KV6GfzQZ+JvD8J_p@mail.gmail.com>
	 <1287508187.1998.3445.camel@laptop>
	 <AANLkTimjabS1MEkheJ0z2keceH=0eEfC_NbyCjZ-Ltxz@mail.gmail.com>
	 <1287573196.3488.2.camel@twins>
	 <AANLkTimtD249SMg3DeyOX3BFpHCtZeq8cU-2g_m-5GKV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 15:04:39 +0200
Message-ID: <1287579879.3488.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 14:42 +0200, Stephane Eranian wrote:
> It may be better to try another approach just for PERF_SAMPLE_READ
> with its own version of ctx->time. What about if on event_sched_in() you
> were snapshotting  ctx->time. Then in the perf_output_read_event(), you'd
> have to compute the time delta and add it to this private version of
> ctx->time and store that in the sample. 

Right, that might work.
