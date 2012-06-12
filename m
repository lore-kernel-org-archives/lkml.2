Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2FLPqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:46:02 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39657 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2FLPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:46:00 -0400
Date: Tue, 12 Jun 2012 08:25:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
Message-ID: <20120612152521.GD2423@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339500907.4999.99.camel@lappy>
 <alpine.LFD.2.02.1206121535180.3086@ionos>
 <20120612144705.GB2423@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206121701350.3086@ionos>
 <1339514114.31548.78.camel@twins>
 <alpine.LFD.2.02.1206121716370.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206121716370.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061215-1780-0000-0000-0000065FF4D8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00147434; UDB=6.00033660; UTC=2012-06-12
 15:45:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:20:10PM +0200, Thomas Gleixner wrote:
> On Tue, 12 Jun 2012, Peter Zijlstra wrote:
> 
> > On Tue, 2012-06-12 at 17:07 +0200, Thomas Gleixner wrote:
> > > Hmm, not sure. The deadlock was not triggered in switch_to. It was
> > > just at the beginning of __schedule()
> > > 
> > > 
> > How can you tell? switch_to() is a macro not a function, it won't ever
> > show up on a stack-trace.. but I think you meant context_switch() but
> > that typically gets inlined, similar problem.
> 
> Bah, I misread the trace and the rcu code. :(
> 
> So, yes the revert should solve the problem. Looks like I need more
> coffee, not Paul :)

Well, given that the commit that I reverted was my own, I definitely
needed more of something or another...  :-)

							Thanx, Paul

