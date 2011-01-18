Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1ARQmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:42:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1ARQl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:41:59 -0500
Date: Tue, 18 Jan 2011 17:41:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: remove superfluous sub instructions
Message-ID: <20110118164148.GD1941@jolsa.brq.redhat.com>
References: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
 <20110118155159.GA1791@nowhere>
 <1295367762.12215.2.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295367762.12215.2.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 11:22:42AM -0500, Steven Rostedt wrote:
> On Tue, 2011-01-18 at 16:52 +0100, Frederic Weisbecker wrote:
> > On Tue, Jan 18, 2011 at 04:28:18PM +0100, Jiri Olsa wrote:
> > > hi,
> > > 
> > > I think there's no need for substracting MCOUNT_INSN_SIZE from the
> > > IP parameter before calling the function trace (/graph) handler.
> > > 
> > > Maybe I overlooked something, but all the IP usage I saw ended
> > > up in the kallsyms_lookup function, which does the lookup using the
> > > functions' start/end boundaries to find the correct symbol for pointer.
> > > 
> > > Thus it seems to me there's no point in substracting the
> > > MCOUNT_INSN_SIZE value from the IP parameter.
> > > 
> > > I tested for x86_64 and got proper results, I believe it's
> > > the same case for x86_32.
> > > 
> > > wbr,
> > > jirka
> > > 
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > 
> > Well, that sounds right after all. If we are only interested in the
> > symbol, the instruction that follows "call mcount" is still relevant
> > as it must belong to the same function.
> > 
> > Steve?
> 
> NAK, it will break function triggers/probes. The "func:traceon" and
> "func:traceoff". They compare the ip to the call location of mcount.
> 
> -- Steve
> 
> 

ops, missed this one..

would it make sense to update the IP inside the function_trace_probe_call
function to save one instruction in the entry code used by all? or it's
not worth it..

jirka
