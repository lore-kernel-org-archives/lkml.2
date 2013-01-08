Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3AHDx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:53:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40359 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3AHDxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:53:54 -0500
Date: Mon, 7 Jan 2013 19:53:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
Message-ID: <20130108035348.GF2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au>
 <50EB252C.4010005@infradead.org>
 <20130107221627.GZ2525@linux.vnet.ibm.com>
 <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
 <1357600327.5190.13.camel@gandalf.local.home>
 <1357605379.5190.15.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357605379.5190.15.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010803-7606-0000-0000-0000073C87CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 07:36:19PM -0500, Steven Rostedt wrote:
> On Mon, 2013-01-07 at 18:12 -0500, Steven Rostedt wrote:
> > On Tue, 2013-01-08 at 09:59 +1100, Stephen Rothwell wrote:
> > > Hi Paul,
> > > 
> > > On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > >
> > > > On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
> > > > > 
> > > > > on i386 or x86_64:
> > > > > 
> > > > > ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> > > > 
> > > > Hello, Randy,
> > > > 
> > > > Did your build include the following, also pushed to -next in that same
> > > > batch from -rcu?  Including Steven Rostedt on CC for his take.
> > > 
> > > That commit was certainly in next-20130107.
> > 
> > Could be bad config dependencies.
> 
> Paul,
> 
> You need to also select TRACE_CLOCK if you are going to use it.

Thank you, Steve!

Randy, does the following patch help?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ce75d3b..b0fe7bd 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1010,6 +1010,7 @@ config RCU_CPU_STALL_INFO
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	depends on DEBUG_KERNEL
+	select TRACE_CLOCK
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.

