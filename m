Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab1AMUls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:41:48 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51119 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942Ab1AMUll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:41:41 -0500
Date: Thu, 13 Jan 2011 12:41:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcu_kthread:6 blocked for more than 120 seconds.
Message-ID: <20110113204135.GK2500@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110112174300.GA6504@flint.arm.linux.org.uk>
 <20110112222219.GA17328@linux.vnet.ibm.com>
 <20110113200526.GA31380@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113200526.GA31380@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 08:05:26PM +0000, Russell King wrote:
> On Wed, Jan 12, 2011 at 02:22:19PM -0800, Paul E. McKenney wrote:
> > Does the following patch help?
> 
> Yes it does, thanks.
> 
> Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> > commit 70ce43253a4465211a9c51e33d56a417c759a718
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Wed Jan 12 14:18:11 2011 -0800
> > 
> >     rcu: avoid pointless blocked-task warnings
> >     
> >     If the RCU callback-processing kthread has nothing to do, it parks in
> >     a wait_event().  If RCU remains idle for more than two minutes, the
> >     kernel complains about this.  This commit changes from wait_event()
> >     to wait_event_interruptible() to prevent the kernel from complaining
> >     just because RCU is idle.
> >     
> >     Reported-by: Russell King <rmk@arm.linux.org.uk>
> 
> Please add '+kernel' in there, thanks.

Done!  FWIW, I copied the original from my email agent.

							Thanx, Paul
