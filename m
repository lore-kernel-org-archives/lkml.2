Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2GSXHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:07:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43484 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab2GSXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:07:36 -0400
Message-ID: <50089323.6050203@zytor.com>
Date: Thu, 19 Jul 2012 16:07:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
References: <20120711195048.885039013@goodmis.org>   <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>   <1342205273.30075.19.camel@gandalf.stny.rr.com>   <1342627145.11900.7.camel@gandalf.stny.rr.com>   <50076ED9.3000100@hitachi.com>   <1342702344.12353.16.camel@gandalf.stny.rr.com>  <1342702682.12353.20.camel@gandalf.stny.rr.com>  <50088FD4.4060401@zytor.com> <1342739063.12353.82.camel@gandalf.stny.rr.com>
In-Reply-To: <1342739063.12353.82.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 04:04 PM, Steven Rostedt wrote:
> On Thu, 2012-07-19 at 15:53 -0700, H. Peter Anvin wrote:
> 
>> lea is not typically faster than add, but in the case of Atom, it is
>> done in an earlier pipeline stage (AGU instead of ALU) which means lea
>> is faster if its inputs are already available as address expressions and
>> is consumed by address expressions; the goal is to avoid the ALU->AGU
>> forwarding latency.
> 
> Well, the question is, which is faster:
> 
> 	lea 8(%esp), %esp
> 	addl $8, %esp
> 
> Basically, all we want to do is add 8 to the stack pointer. And this is
> for the x86_32 version of whatever hardware is in use.
> 

What I'm telling you is that it depends on the context.

An address expression needs to be ready in the AGU; a piece of data
comes from the ALU.  Whenever something moves from the ALU to the AGU,
there is a penalty.  There is no penalty to move from the AGU to the
ALU, since the ALU is in a later stage.

I *believe* the stack adjustments push/pop are done in the AGU, but I
have to double-check.

	-hpa

