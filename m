Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422818Ab2LGQgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:36:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762Ab2LGQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:36:42 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=pnEMnE1cHRhEj4W9Bt0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354898200.17101.50.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 11:36:40 -0500
In-Reply-To: <20121207162346.GW14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 16:23 +0000, Russell King - ARM Linux wrote:

> That's fine if there are better ways.  If your view is that this would
> bring things "up to the future" consider this: what you suggest is possible
> with the standard ARM 32-bit instruction set.  With the more modern Thumb
> instruction set, because we now effectively have prefixes, where those
> prefixes control the execution of the following instructions, what you
> suggest becomes no longer possible.
> 
> So, it's not a question of bringing stuff up to the future at all... you
> can call it a design regression of you will, but you're really making
> demands about how CPUs work which are outside of your remit.
> 
> Think of this a bit like you changing the opcodes immediately following a
> 'LOCK' prefix on x86.  I suspect divorsing the following opcodes from its
> prefix would be very bad for the instructions atomicity.

But what about the limitations that the function tracer imposes on the
code that gets modified by stop_machine()?

1) the original code is simply a call to mcount

2) on boot up, that call gets converted into a nop

3) the code that gets changed will only be converting a nop to a call
into the function tracer, and back again.

IOW, it's a very limited subset of the ARM assembly that gets touched.
I'm not sure what the op codes are for the above, but I can imagine they
don't impose the prefixes as you described.

If that's the case, is it still possible to change to the breakpoint
method?

-- Steve


