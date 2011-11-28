Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1K1UYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:24:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1K1UY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:24:28 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6ethm6nK9TkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=cPp6oPMhpPXNJP0fy2IA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <1322511307.2921.173.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo>  <1322510552.2921.167.camel@twins>
	 <1322511125.17003.21.camel@frodo>  <1322511307.2921.173.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:24:26 -0500
Message-ID: <1322511866.17003.33.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:15 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 15:12 -0500, Steven Rostedt wrote:
> > Actually, from what I've been told, x86 seems to be the only arch that
> > does crazy things with NMIs. Most the other archs do NMI when the system
> > is dead. That is, there's no return to normal system processing once an
> > NMI is hit. 
> 
> Sparc64 implements effective NMIs by playing games with their interrupt
> priority levels. local_irq_disable() disable the lower 15 (0-14) levels
> only, and their PMU interrupts at level 15.
> 
> That generates an effective NMI (interrupt not blocked by
> local_irq_disable()).

[ Added David ]

I think it's ok on sparc to modify code on one processor while another
processor is executing it. If not then we need the tricks that x86 does,
but if its ok, then we don't even need stop_machine();

-- Steve


