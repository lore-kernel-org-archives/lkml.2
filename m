Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0KJSJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:09:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0KJSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:09:50 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=v8S-NHSWYNb9HVcEVAoA:9 a=bWjapmQ2s5g3xtO536ZGr5ZcI7oA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101110174122.GA4001@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>
	 <1289407960.12418.169.camel@gandalf.stny.rr.com>
	 <20101110170559.GA15704@a1.tnic>  <20101110174122.GA4001@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 13:09:47 -0500
Message-ID: <1289412587.12418.179.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 18:41 +0100, Ingo Molnar wrote:

> > It would also be cool to be able to allocate those buffers as early as possible, 
> > even if before MCA is enabled, so that I won't have to copy MCE data which got 
> > logged before the tracing subsystem got enabled to the buffers proper.
> 
> We could even have some (small) statically enabled build-time buffer that could be 
> enabled straight away before any allocators are enabled.

I'm not sure it needs to be small. We can have a persistent buffer that
may be resized at any time. It can start off small, or with a kernel
command line, be as big as you want it.

Basically, what ftrace has now.

Also, with a way that root user can get a handle on this buffer, and
just trace global events with it.

-- Steve


