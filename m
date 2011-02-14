Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1BNPOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:14:35 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56471 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1BNPOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:14:34 -0500
Date: Mon, 14 Feb 2011 07:14:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Why does the 2.6.37 scheduler hate RT tasks?
Message-ID: <20110214151402.GA2256@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110202011049.GA15084@linux.vnet.ibm.com>
 <20110214145549.GB2937@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214145549.GB2937@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:55:49PM +0800, Yong Zhang wrote:
> On Tue, Feb 01, 2011 at 05:10:49PM -0800, Paul E. McKenney wrote:
> > Hello, Peter,
> > 
> > If I create an SCHED_FIFO-priority kthread in pre-2.6.37 kernels,
> > things work nicely.  If I try in in later kernels, __disable_runtime()
> > gets upset occasionally during CPU-hotplug calls when CPUs are inserted.
> > If I make the exact same kthreads run SCHED_NORMAL, no problem.
> > 
> > Unfortunately, I need an RT kthread so that I can do priority boosting.
> > 
> > My next thing to try is to demote my kthreads to SCHED_NORMAL at the
> > beginning of a CPU-hotplug event and promote them back to SCHED_FIFO at
> > the end of the CPU-hotplug event, which would leave the system vulnerable
> > to RCU priority inversion during CPU-hotplug events.  This would be
> > better than the current behavior, but I thought that I should check with
> > you to see if there is a better approach.
> 
> Just want to know the status of this issue :)
> 
> Does commit 06c3bc655697b19521901f9254eb0bbb2c67e7e8 cure it?

Ah, good to see that this got in!  I did extract it from the diagnostic
patch that Peter sent out, and it does seem to cure the issue.

							Thanx, Paul
