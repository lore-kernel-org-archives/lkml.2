Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0LUVdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:33:40 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:58211 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0LUVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nq32PzHB8iF+ypdYXHqB8OCqd2wK76ccaJcU/iIEGNdgj9Td9DXCmNiqH+l/2kHv4P
         kVix9RbUI1a9RaEbvJoSX+KvN6dBon5foHUS63bD98utkVTLXnBlDHQliYc6d5MGpYNc
         cjlY81T9qdXyyVprKkQvXUNEFqRLsH6fHFQC0=
Date: Tue, 21 Dec 2010 22:33:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
Message-ID: <20101221213331.GT1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
 <20101221183131.GO1750@nowhere>
 <1292956832.2170.17.camel@laptop>
 <20101221184516.GP1750@nowhere>
 <1292957546.2170.21.camel@laptop>
 <20101221190203.GQ1750@nowhere>
 <1292961383.2170.31.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292961383.2170.31.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:56:23PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 20:02 +0100, Frederic Weisbecker wrote:
> 
> > This could be a PERF_SAMPLE_RAW may be?
> 
> Well clearly not ;-)
> 
> But maybe we can do something like: PERF_RECORD_SAMPLES (note the
> plural):
> 
> struct {
> 	struct perf_event_header		header;
> 
> 	u64					nr;
> 	u32					common_type;
> 	u32					data_type;
> 
> 	struct perf_sample			common;
> 	struct perf_sample			data[nr];
> }
> 
> Where struct perf_sample is PERF_RECORD_SAMPLE without the
> perf_event_header bit.
> 
> Where we can split the many samples into a piece that is the same for
> all perf_samples::common, where the content specified by the
> PERF_SAMPLE_ bits from ::common_type, and the the rest lives in data[]
> specified by the PERF_SAMPLE_ bits from ::data_type.


Well, yeah but that involves some new corner cases in both the kernel
and userspace.

What about a generic branch record like:

struct branch {
	u64 nr;
	struct {
		u64 from;
		u64 to;
	}[nr]
}

This is going to be useful also when one day we'll
support the function tracer, lbr and so...
