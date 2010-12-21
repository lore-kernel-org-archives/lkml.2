Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0LUVlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:41:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:44385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0LUVlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:41:05 -0500
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20101221213331.GT1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
	 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
	 <20101221183131.GO1750@nowhere> <1292956832.2170.17.camel@laptop>
	 <20101221184516.GP1750@nowhere> <1292957546.2170.21.camel@laptop>
	 <20101221190203.GQ1750@nowhere> <1292961383.2170.31.camel@laptop>
	 <20101221213331.GT1750@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 22:41:04 +0100
Message-ID: <1292967664.2170.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 22:33 +0100, Frederic Weisbecker wrote:
> On Tue, Dec 21, 2010 at 08:56:23PM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-12-21 at 20:02 +0100, Frederic Weisbecker wrote:
> > 
> > > This could be a PERF_SAMPLE_RAW may be?
> > 
> > Well clearly not ;-)
> > 
> > But maybe we can do something like: PERF_RECORD_SAMPLES (note the
> > plural):
> > 
> > struct {
> > 	struct perf_event_header		header;
> > 
> > 	u64					nr;
> > 	u32					common_type;
> > 	u32					data_type;
> > 
> > 	struct perf_sample			common;
> > 	struct perf_sample			data[nr];
> > }
> > 
> > Where struct perf_sample is PERF_RECORD_SAMPLE without the
> > perf_event_header bit.
> > 
> > Where we can split the many samples into a piece that is the same for
> > all perf_samples::common, where the content specified by the
> > PERF_SAMPLE_ bits from ::common_type, and the the rest lives in data[]
> > specified by the PERF_SAMPLE_ bits from ::data_type.
> 
> 
> Well, yeah but that involves some new corner cases in both the kernel
> and userspace.

Hardly.

> What about a generic branch record like:
> 
> struct branch {
> 	u64 nr;
> 	struct {
> 		u64 from;
> 		u64 to;
> 	}[nr]
> }
> 
> This is going to be useful also when one day we'll
> support the function tracer, lbr and so...

No, since that suffers the exact same problem you currently have, no
TIME,TID,etc.. Nor is it quite usable for LBR since there is no clear
means of associating it with a previous PERF_RECORD_SAMPLE.

(LBR really is quite different from BTS)
