Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2LJOGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:06:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2738 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2LJOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:06:08 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=ynV7WPCXtcIjeggMEsMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355148365.17101.168.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Dec 2012 09:06:05 -0500
In-Reply-To: <20121210135747.GK14363@n2100.arm.linux.org.uk>
References: <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
	 <20121210100433.GB6624@mudshark.cambridge.arm.com>
	 <1355144537.17101.155.camel@gandalf.local.home>
	 <20121210135747.GK14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 13:57 +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 10, 2012 at 08:02:17AM -0500, Steven Rostedt wrote:
> > On Mon, 2012-12-10 at 10:04 +0000, Will Deacon wrote:
> > > Yes, and I think if you do use two 16-bit nops, you can even get rid of all
> > > the intermediate `sync' operations (I guess you might want one at the end if
> > > you want the call to become visible at a particular point).
> > 
> > Wont work. We are replacing a 32bit call with a nop. That nop must also
> > be 32bits, because we could eventually replace the nop(s) with a 32bit
> > call.
> 
> ... which, if it's misaligned to a 32-bit boundary, which can happen with
> Thumb-2 code, will require the replacement to be done atomically; you will
> need to use stop_machine() to ensure that other CPUs don't try to execute
> the instruction mid-way through modification... as I have already
> explained in my previous mails.

If there's no way to modify a 32bit operation without stop_machine(),
ever with a breakpoint, than we can stop the discussion here. ARM will
forever require stop_machine() for use with tracepoints and ftrace. Too
bad, as ARM was the x86 competitor. Here's something that x86 has a one
up on ARM.

-- Steve


