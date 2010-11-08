Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KHOXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:23:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0KHOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:23:07 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=rbwYpscXq5kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ydLok6ndYEzbqPBon7QA:9 a=jGmYNqxC_ka_ipMgsGMLb4pTFPcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20101108141420.GA12548@infradead.org>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20101108095610.GA22592@infradead.org>
	 <5b55a1$ijitko@fmsmga002.fm.intel.com>
	 <1289224934.12418.1.camel@gandalf.stny.rr.com>
	 <20101108141420.GA12548@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Nov 2010 09:23:04 -0500
Message-ID: <1289226184.12418.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 09:14 -0500, Christoph Hellwig wrote:
> On Mon, Nov 08, 2010 at 09:02:14AM -0500, Steven Rostedt wrote:
> > I like the trace=on parameter much better. If that is set we could
> > enable the tracepoints of that module at load time. I really do not want
> > to export the function that was proposed in that patch.
> 
> Yes.  Adding generic support in the module loader to turn on tracepoint
> seems like the much better long term strategy.  Even better if it allows
> turning on individual points instead of all or nothing.

I was thinking the same. How about this:

trace=1  - all tracepoints in the module is enabled
trace=0  - same as leaving it off

trace=name - a specific tracepoint is enabled, using the simple globs
that set_event allows.

trace=name1,name2,name3  - for more than one tracepoint.

-- Steve


