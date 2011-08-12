Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1HLNJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:09:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1HLNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:08:59 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=_E3Q4npPQ1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xXBO3Si2C59_4isJ1vEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on
 ftrace nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <4E44967C.1090101@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <4E43209D.7090104@hitachi.com>
	 <1313022842.18583.282.camel@gandalf.stny.rr.com>
	 <4E43769C.9000901@hitachi.com>
	 <1313067691.18583.290.camel@gandalf.stny.rr.com>
	 <4E44967C.1090101@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 09:08:57 -0400
Message-ID: <1313154537.18583.319.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 11:57 +0900, Masami Hiramatsu wrote:

> I don't think it won't work. It can work but on a long way.
> Could you tell me your "bigger ideas"? Perhaps, we are on the different
> way but aim to same goal.

Part of the bigger ideas is to have things like function graph tracing
use this, as it will simplify the entry.S code. There's other things
that may come out of this too.

> 
> >> The cons:
> >> - Native kprobes users will be disappointed... anyway, they just need to
> >>   move their probes to the next instruction (usually addr+=5 is OK).
> >
> > I've been told that doing the addr+=5 (which is also arch specific) can
> > break things for other tools.
> 
> As I told in previous mail, I think kprobes can do that transparently.

Yeah, it could, but I'm afraid this may need to be done differently for
every arch. If I'm working on getting this code to work for ftrace,
which will require modifying ever arch as well, kprobes can get the
changes for free.

-- Steve



