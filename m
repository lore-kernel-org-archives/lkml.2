Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2GZRlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:41:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48977 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2GZRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:41:10 -0400
Date: Thu, 26 Jul 2012 10:39:02 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 6/7] kdb: Mark safe commands as KDB_SAFE and
 KDB_SAFE_NO_ARGS
Message-ID: <20120726173902.GA20023@lizard>
References: <20120726142514.GA32158@lizard>
 <1343312791-9138-6-git-send-email-anton.vorontsov@linaro.org>
 <20120726180709.09777a3b@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120726180709.09777a3b@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 06:07:09PM +0100, Alan Cox wrote:
> > The following commands were marked as "safe":
> > 
> > 	Clear Breakpoint
> > 	Enable Breakpoint
> > 	Disable Breakpoint
> > 	Display exception frame
> > 	Stack traceback
> 
> This is sufficient to steal cryptographic keys in many environments. In
> fact you merely need two or three breakpoints and to log the order they
> are hit through the crypto computation.

Neat. :-)

Breakpoints are no good then.

> > 	Display stack for process
> 
> Exposes all sorts of user data unless you mean just the call trace, in
> which case it's still quite useful.
> 
> > 	Display stack all processes
> 
> Ditto

What I think is, should we just mark single stepping (as well as
breakpoints) as unsafe, then it's hard to impossible to use the call
trace as something meaningful?

> > 	Send a signal to a process
> 
> Like say sending SIGSTOP to security monitoring threads or the battery
> manager on locked devices that rely on software battery management ?

Yeah, will need to zap it too.

> It's an interesting idea but you need almost nothing to extract keys from
> a system or to subvert it.

Apart from the above issues?


(Now it might seem that we cut almost everything from the KDB, but KDB is
not just about ordinary debugging facilities, like breakpoints or
variables watch. KDB is a shell that also implements commands to query
kernel about its state: e.g. in Android case there is "irqs" commands that
just shows interrupts counters, that is a nice feature if used w/ KDB
NMI/FIQ debugger[1], so you can see which interrupt is misbehaving.
There is also a 'dmesg' command, and 'summary' and maybe others.)

Thanks!

[1] http://lwn.net/Articles/506673/

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
