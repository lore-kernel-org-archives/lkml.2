Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2G3RJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:09:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55713 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab2G3RJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:09:09 -0400
Date: Mon, 30 Jul 2012 10:08:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Feng Tang <feng.tang@intel.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mail List <linux-kernel@vger.kernel.org>
Subject: Re: [Regression 3.4] tick_broadcast_mask is not restored after a CPU
 has been offline/onlined
Message-ID: <20120730170847.GE2391@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120730151559.772d4055@feng-i7>
 <20120730133913.GK2556@linux.vnet.ibm.com>
 <20120730230747.7637112a@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730230747.7637112a@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073017-9360-0000-0000-000008E9E3AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:07:47PM +0800, Feng Tang wrote:
> Hi Paul,
> 
> On Mon, 30 Jul 2012 06:39:13 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Mon, Jul 30, 2012 at 03:15:59PM +0800, Feng Tang wrote:
> > > Hi All,
> > > 
> > > When I debugged a suspend/resume bug, I found that tick_broadcast_mask is
> > > not restored for a CPU after it is offline/onlined since kernel 3.4, while
> > > it's fine for 3.3.
> > 
> > Could you please try 3.5?
> 
> Yes, it's the same for 3.5

Thank you for checking, Feng.

Len, the comment above the change says:

	/*
	 * FIXME:  Design the ACPI notification to make it once per
	 * system instead of once per-cpu.  This condition is a hack
	 * to make the code that updates C-States be called once.
	 */

Is it time for this design-level change?  Or is there something obvious
that I missed when fixing the smp_processor_id() splat?

I could revert back, but use raw_smp_processor_id() rather than
smp_processor_id(), but that feels like papering over a problem rather
than fixing it.

Thoughts?

							Thanx, Paul

