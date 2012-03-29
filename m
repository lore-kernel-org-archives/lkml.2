Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab2C2X7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:59:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:38583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2C2X7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:59:30 -0400
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        rostedt@goodmis.org, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
	 <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 01:59:19 +0200
Message-ID: <1333065559.2960.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 10:04 -0700, Stephane Eranian wrote:
> I think the mechanism should allow the user to select which registers
> (you have that) but also where they are captured. You have
> the user level state, but you also want the interrupted state or the
> precise state, i.e., extracting the register at retirement of an
> instruction
> that caused the sampling PMU event (PEBS on Intel). Personally, I
> am interested in the last two. I had a prototype patch for those.
> It is based on the same approach in terms of register naming. You
> need to be able to name individual registers. That's obviously arch
> specific and you have that. Now there needs to be a way to indicate
> where the registers must to be captured. Note that you may want
> to combine user + interrupt states. So I think we may need multiple
> register bitmasks. 

This all comes very close to something I suggested to Masami once where
you could specify data to grab on [ku]probe hits. 

That is, when creating a [ku]probe based tracepoint you can specify
several variable/argument names and the userspace perf-probe bits will
use the dwarf info to figure out how to obtain the value of said var/arg
at the probe point (if possible, if not bail).

The kernel would simply get something along the lines of %rax->foo->bar,
or (%esp+x)->blah along with a size of the data structure to be found
there and copy whatever it finds out to the raw field.

So what you're saying is you basically want this for any possible
sample, not just [ku]probes.



