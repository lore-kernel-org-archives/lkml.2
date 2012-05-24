Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2EXW5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab2EXW5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:57:09 -0400
Date: Thu, 24 May 2012 18:57:03 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120524225703.GA31149@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
References: <20120524160146.GA6226@redhat.com>
 <1337876398.13348.178.camel@gandalf.stny.rr.com>
 <20120524172223.GA10689@redhat.com>
 <1337880914.13348.189.camel@gandalf.stny.rr.com>
 <20120524184728.GA13201@redhat.com>
 <1337885672.13348.194.camel@gandalf.stny.rr.com>
 <20120524191147.GA13936@redhat.com>
 <1337887495.13348.195.camel@gandalf.stny.rr.com>
 <20120524200541.GA6552@redhat.com>
 <1337899781.13348.208.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337899781.13348.208.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 06:49:41PM -0400, Steven Rostedt wrote:
 > On Thu, 2012-05-24 at 16:05 -0400, Dave Jones wrote:
 > > On Thu, May 24, 2012 at 03:24:55PM -0400, Steven Rostedt wrote:
 > >  > On Thu, 2012-05-24 at 15:11 -0400, Dave Jones wrote:
 > >  > 
 > >  > >  > Also, how reproducible is it? When it triggered for me, it was constant.
 > >  > >  > Every boot and test failed. But after I did the make mrproper, I have
 > >  > >  > not been able to trigger it again. This is why I put it down as a bad
 > >  > >  > build.
 > >  > > 
 > >  > > happens every time for me so far.
 > >  > 
 > >  > Did you also do a make mrproper and try again?
 > > 
 > > ok, that's nasty.  Works fine after a make clean.
 > > 
 > 
 > Hmm, I did two make mrproper builds and they both failed. So this isn't
 > a build issue. Must just be some nasty race. I'm still leaning that this
 > has to do with the breakpoint function tracing updates.
 > 
 > Looking deeper into it.
 > 
 > -- Steve

Possibly unrelated, but I found that it only worked once per boot. Is that expected ?

echo irqsoff > current_tracer
echo latency-format > trace_options
echo 0 > tracing_max_latency
echo 1 > tracing_on
blah
echo 0 > tracing_on
cat trace

showed me a trace as I expected

repeating the same commands then got me an empty trace.

what gives ?

	Dave

