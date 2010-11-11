Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0KKQKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:10:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0KKQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:10:19 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=0Gcdu3wDtgIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Umf96XxzPD-RLq3YjVUA:9 a=7RQWeVrKzwWrDhUraRqu5FkQlrcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101111001110.GA32564@Krystal>
References: <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
	 <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu>
	 <1289415645.12418.180.camel@gandalf.stny.rr.com>
	 <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>
	 <20101110213033.GA7682@nowhere>  <20101111001110.GA32564@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Nov 2010 11:10:16 -0500
Message-ID: <1289491816.12418.255.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 19:11 -0500, Mathieu Desnoyers wrote:

> > There are also the other common fields:
> > 
> > 	struct trace_entry {
> > 		unsigned short		type;
> > 
> > 
> > Type is needed by perf. If we have one buffer per event, we could
> > retrieve which event we are dealing with. But if buffers are
> > multiplexed per cpu, we need this.
> 
> Agreed, although 65536 types ID is probably overkill for the common case.
> I prefer to go for approaches with a header that contains a smaller number of
> bits, and use an extended header for those rare cases that need it.

Note, ftrace currently has over 600 event types. Unless we compact it
down into bits, using two bytes is fine.

-- Steve


