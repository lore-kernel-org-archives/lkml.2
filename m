Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab2EPSRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:17:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab2EPSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:17:31 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4e99ZUtEKCT8sPAI1DYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337192248.6724.60.camel@gandalf.stny.rr.com>
Subject: Re: Perf record format portability
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 16 May 2012 14:17:28 -0400
In-Reply-To: <20120516180830.GH7864@infradead.org>
References: <4FB275EB.5050904@linaro.org>
	 <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>
	 <20120516145927.GC7864@infradead.org>
	 <1337187503.6724.50.camel@gandalf.stny.rr.com>
	 <20120516180830.GH7864@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 15:08 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 16, 2012 at 12:58:23PM -0400, Steven Rostedt escreveu:
> > On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:
> > > 	Was the kernel trace events infrastructure designed with that in
> > > mind? I.e. cross analysis? I must be missing something here, still
> > > ENOCOFFEE :-\
> > 
> > Yes, the libparsevents library was design for this from day one. That's
> > why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
> > whatever. I did all my development testing against 32bit, 64bit and big
> > and little endian. This was the case from the beginning.
> 
> I need to look at the code, but how does it do this? Copy the relevant
> /sys/kernel/debug/events formats in the header and then instead of
> looking at /sys/... look at those?

It does copy the events from .../debug/tracing/events. But it does cheat
about the bits. To determine the size, it looks
at /sys/kernel/debug/tracing/events/header_page and the field of
"commit". On 32bit machines, that's 4bytes, and on 64bit, that's 8
bytes.

For endianess, that is calculated on the machine that the recording is
running on and stored in the file.

The parse-events structure has a way to record the endianess and long
size, for later retrieval.

> 
> Does it still copy /proc/kallsyms?

Yes it does.

-- Steve


