Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2APMbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:31:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2APMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:31:13 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=UWWz3wwl9CY8JkZ3BBkA:9 a=DD0cWEDW_tyIYdB-O7kA:7 a=PUjeQqilurYA:10 a=rbZnrCqY1qe5Senz:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326717070.7642.144.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 16 Jan 2012 07:31:10 -0500
In-Reply-To: <20120116074540.GE15641@elte.hu>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 08:45 +0100, Ingo Molnar wrote:

> Looks good to me at a first (quick) sight, except this bit 
> which changes the ABI:
> 
> > > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
> 
> That's not how we change tracepoints generally - we add a new 
> one and eventually phase out the old one. Which apps/tools rely 
> on the old tracepoint? If it's exactly zero apps then we might 
> be able to change it, but this needs to be investigated.

But this tracepoint wasn't changed, it was added on to. There's a
difference. Any tool that uses this (including something like powertop)
should be able to handle it. It should be no different than adding
to /proc/stat. We don't create a new /proc file when adding to it. The
original structure is still intact here.

We really need to get a parsing library out to the public. That would
avoid all these issues as the TRACE_EVENT() was originally designed to.

-- Steve



