Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3AHWZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:25:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3AHWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:25:14 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SD-9uMGPD0kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=TYDqRA5Orc4A:10 a=STcySFxzXlwVZYK1Y6wA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357683913.5190.47.camel@gandalf.local.home>
Subject: Re: [add to stable] ftrace: Do not function trace inlined functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Jan 2013 17:25:13 -0500
In-Reply-To: <20130108221006.GA29782@kroah.com>
References: <1357681121.5190.42.camel@gandalf.local.home>
	 <20130108221006.GA29782@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 14:10 -0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 08, 2013 at 04:38:41PM -0500, Steven Rostedt wrote:
> > Hi Greg and Ben,
> > 
> > Can you add commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a to the
> > stable trees.
> 
> That showed up in 3.3-rc1, so I don't think it's needed in 3.2-stable.

Well, it should have been marked for stable, which means it missed 3.2.

> 
> But why add it now?  What does it "fix" for 3.4 and 3.7?
> 

When gcc doesn't inline a function marked inline (with different
compilers, it does different things), a function that shouldn't be
traced gets traced by the function tracer. The result is a kernel crash,
which usually ends up being a triple fault (automatic reboot, hard to
debug).

That's because some low level function like local_irqs_disable() gets
traced, which is used in the function tracer recursion protection. Which
means, that it's outside the recursion protection and when you enable
function tracing, it causes the system to reboot.

Thomas just hit this on 3.2-rt, and was asking me why it wasn't marked
for stable. I just didn't think of it at the time.

-- Steve


