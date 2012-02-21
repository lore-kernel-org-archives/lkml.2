Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2BUKPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:15:53 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60384 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2BUKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:15:52 -0500
Date: Tue, 21 Feb 2012 11:15:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120221101541.GB14274@aftab>
References: <20120220145920.GB5728@aftab>
 <1329786868.25686.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329786868.25686.50.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 08:14:28PM -0500, Steven Rostedt wrote:
> On Mon, 2012-02-20 at 15:59 +0100, Borislav Petkov wrote:
> 
> > * I'd like to have conditional printk-ing in trace_mce_record depending
> > on the TP args, Steve probably knows what can be done:
> 
> /me is confused :-)

Yeah, sorry. I'll explain to you in more detail when you get over here
next month :-).

> > 
> > @Steven:
> > 
> > I'd like to do the following:
> > 
> > 	TP_printk("%s, ARG1: %d, ARG2: %c ...", str1, arg1, arg2)
> > 
> > and have it print only the first arg, i.e. the string and drop the rest
> > of the args while still doing the TP_fast_assign into the ring buffer
> > and carrying the stuff to its consumers. Background is that I want to
> > dump the decoded string of a hardware error, if it is decoded, but carry
> > the MCE info to userspace and only dump the fields of the MCE if I
> > haven't managed to decode it, i.e. str1 == "".
> > 
> > So, my question is, can I do something like:
> > 
> > 	TP_printk("%s, ARG1: %d, ARG2: %c ...", __print_conditional(str1, arg1, arg2))
> 
> You want to affect the output of ftrace?
> 
> perf and even trace-cmd do the parsing later and can be overridden.
> Well, perf can be when we finally get it to use the updated trace-cmd
> parser.

Right, that's another possibility. I simply didn't want to burden the
ring buffer with useless stuff we aren't going to use but I guess a
couple of tens of bytes aren't the world :)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
