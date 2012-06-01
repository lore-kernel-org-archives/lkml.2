Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab2FALhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 07:37:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2FALhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 07:37:10 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=A73EdQgzBtYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=7LbZ8pxXUWzXXegPjNQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338550627.13348.462.camel@gandalf.stny.rr.com>
Subject: Re: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, acme <acme@ghostprotocols.net>,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 01 Jun 2012 07:37:07 -0400
In-Reply-To: <4FC84AC8.3020601@hitachi.com>
References: <20120531012829.160060586@goodmis.org>
	  <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	  <1338473302.13348.336.camel@gandalf.stny.rr.com>
	  <1338486029.28384.93.camel@twins>
	  <1338486820.13348.366.camel@gandalf.stny.rr.com>
	  <1338487413.28384.103.camel@twins>
	  <1338490218.13348.379.camel@gandalf.stny.rr.com>
	  <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>
	  <1338495006.13348.418.camel@gandalf.stny.rr.com>
	  <1338495969.28384.119.camel@twins>
	  <1338496676.13348.430.camel@gandalf.stny.rr.com>
	  <1338496857.28384.124.camel@twins>
	 <1338497360.13348.438.camel@gandalf.stny.rr.com>
	 <4FC84AC8.3020601@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 13:53 +0900, Masami Hiramatsu wrote:

> Hmm, why don't we have two text_poke interfaces for single and
> batch? As like dyn_ftrace, since modifying massive points takes
> a lot time, so we may have additional kconfig something like
> CONFIG_QUICK_BATCH_TEXT_POKE which switches text area to rw while
> batch text_poke.
> 

I'll be working on patches to consolidate the two after I get everything
else working :-)  I still need to work on the ftrace kprobe stuff too.

I hate having a config option to switch between the two, except for
something that can be there if we find the new approach is buggy (like
we have with lockdep). That may be a solution for this if we don't agree
on one now. That is, bring back stop_machine() when LOCKDEP is enabled.
But that should only be a temporary work around not a true fix.

I have no problem with having most of the modifying code be shared
between text_poke and ftrace. I guess the question is, do we want to do
it only with the FIXMAP or do we want text_poke and ftrace to use the rw
method for large batches. Heck, we can set a limit. If we are going to
update more that 100 locations, we switch the kernel to rw, otherwise we
do the FIXMAP update.

-- Steve


