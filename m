Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2FYN27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:28:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51596 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab2FYN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:28:58 -0400
Date: Mon, 25 Jun 2012 06:20:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
Message-ID: <20120625132037.GW2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120623101251.GA10162@localhost>
 <20120623170147.GI2516@linux.vnet.ibm.com>
 <20120623174830.GA5617@localhost>
 <CAM_iQpW-vtnHUOBoROueui-FCrw9zB4U3vwy=PnEOLXP713WWw@mail.gmail.com>
 <20120625035733.GU2516@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1206250208210.24381@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206250208210.24381@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062513-8974-0000-0000-00000A802CC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 02:10:23AM -0700, David Rientjes wrote:
> On Sun, 24 Jun 2012, Paul E. McKenney wrote:
> 
> > But in my case, the trailing preempt_enable() should not have been
> > optimized away, right?  Wouldn't it be more like the following?
> > 
> > int a = 0;
> > int main(void)
> > {
> > 	a++;
> > 	return ++a;
> > 	a++;
> > }
> > 
> > Hmmm...  But this -still- doesn't emit any warnings.
> > 
> 
> gcc removed -Wunreachable-code a couple years ago.  It doesn't complain 
> when you pass it for backwards compatibility with old Makefiles.

Ah well, back to manual inspection, then.  :-/

							Thanx, Paul

