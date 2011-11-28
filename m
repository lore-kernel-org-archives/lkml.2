Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1K1UMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:12:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1K1UMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:12:07 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6ethm6nK9TkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=zHoYi5kS0H-_Q2mZ-l0A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <1322510552.2921.167.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo>  <1322510552.2921.167.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:12:05 -0500
Message-ID: <1322511125.17003.21.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:02 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 14:26 -0500, Steven Rostedt wrote:
> > 
> > Are jump labels safe in NMI context yet? If not, this will need to wait
> > till we make it so. 
> 
> I don't think they are, we currently very much rely on that
> stop_machine() crap. NMIs can go straight through that.

Ftrace has a way around it, it would be trivial (well maybe ;) to add
the same to jump labels.

> 
> I think you can make it work with the stop_machine()-less approach,
> because then the NMI will trap on the INT3 which will wait for
> completion, sync and resume the NMI.
> 
> That of course relies on the NMI vs IRET crap getting sorted.
> 
> But even then, that's highly arch specific and I'm not sure we can make
> all archs that support both jump_label and NMIs work.

Actually, from what I've been told, x86 seems to be the only arch that
does crazy things with NMIs. Most the other archs do NMI when the system
is dead. That is, there's no return to normal system processing once an
NMI is hit.

Another thing is, most systems are OK in modifying code on SMP, and
stop_machine isn't even needed for that. I have code to test this out on
PowerPc, and it seems to work well.

-- Steve


