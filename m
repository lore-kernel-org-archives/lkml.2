Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1GKUPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:15:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35321 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1GKUPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:15:22 -0400
Date: Mon, 11 Jul 2011 13:15:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110711201508.GN2245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
 <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711193021.GA2996@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 03:30:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > Hmmm...  Does the stall repeat about every 3.5 minutes after the first stall?
> 
> Starting Configure read-only root support...
> [   81.335070] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=60002 jiffies)
> [   81.335091] sending NMI to all CPUs:
> [  261.367071] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=240034 jiffies)
> [  261.367092] sending NMI to all CPUs:
> [  441.399066] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=420066 jiffies)
> [  441.399089] sending NMI to all CPUs:

OK, then the likely cause is something hanging onto the CPU.  Do the later
stalls also show stack traces?  If so, what shows up?

(Documentation/RCU/stallwarn.txt for more info on this.)

> > 
> > One thing to try would be to disable CONFIG_RCU_FAST_NO_HZ.  I wouldn't
> > expect this to have any effect, but might be worth a try.  It is really
> 
> Did not help.

Well, I guess it met my expectations.  Thank you for trying it!

							Thanx, Paul

> > intended for small battery-powered systems.
> > 
