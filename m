Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1ARQWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:22:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1ARQWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:22:45 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=I98iFNk1EVwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=WsfaRA9WOQoGbdIM5TwA:9 a=Dgeb5pJwGuZ7ertf20gA:7 a=66UXReAZPk1K1ExzBbBE2UHAHEUA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: remove superfluous sub instructions
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110118155159.GA1791@nowhere>
References: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
	 <20110118155159.GA1791@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 18 Jan 2011 11:22:42 -0500
Message-ID: <1295367762.12215.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 16:52 +0100, Frederic Weisbecker wrote:
> On Tue, Jan 18, 2011 at 04:28:18PM +0100, Jiri Olsa wrote:
> > hi,
> > 
> > I think there's no need for substracting MCOUNT_INSN_SIZE from the
> > IP parameter before calling the function trace (/graph) handler.
> > 
> > Maybe I overlooked something, but all the IP usage I saw ended
> > up in the kallsyms_lookup function, which does the lookup using the
> > functions' start/end boundaries to find the correct symbol for pointer.
> > 
> > Thus it seems to me there's no point in substracting the
> > MCOUNT_INSN_SIZE value from the IP parameter.
> > 
> > I tested for x86_64 and got proper results, I believe it's
> > the same case for x86_32.
> > 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Well, that sounds right after all. If we are only interested in the
> symbol, the instruction that follows "call mcount" is still relevant
> as it must belong to the same function.
> 
> Steve?

NAK, it will break function triggers/probes. The "func:traceon" and
"func:traceoff". They compare the ip to the call location of mcount.

-- Steve


