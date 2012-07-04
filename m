Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2GDTHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 15:07:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47749 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2GDTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 15:07:38 -0400
Date: Wed, 4 Jul 2012 12:07:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120704190731.GE2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1341006040.26928.4.camel@lappy>
 <1341225139.23484.4.camel@twins>
 <20120702113541.GI2907@linux.vnet.ibm.com>
 <1341230352.23484.7.camel@twins>
 <1341234773.2958.4.camel@lappy>
 <20120702133334.GA2508@linux.vnet.ibm.com>
 <20120702142252.GA22868@linux.vnet.ibm.com>
 <1341239813.2958.7.camel@lappy>
 <20120702145927.GD2508@linux.vnet.ibm.com>
 <1341413691.18786.0.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341413691.18786.0.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070419-4242-0000-0000-00000236D976
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 04:54:51PM +0200, Sasha Levin wrote:
> On Mon, 2012-07-02 at 07:59 -0700, Paul E. McKenney wrote:
> > On Mon, Jul 02, 2012 at 04:36:53PM +0200, Sasha Levin wrote:
> > > Looks like its running fine for a bit now (~10 min). I'll ping if
> > > anything changes, but on the other tests it has usually failed at this
> > > point.
> > If testing goes well (both yours and mine), I will be submitting this
> > as urgent, since it is a 3.5 regression.  If they don't take it, I will
> > queue it for 3.6.
> 
> 2 days later, and this didn't reproduce. I think we can say it's solved.

Very good, and thank you very much for all your testing efforts!

I have added a ten-microsecond delay to __rcu_read_unlock() under a
new CONFIG_RCU_PROVE_DELAY, and have added this to my testing regimen.
And I guess I have also added it in a probabilistic manner to the various
randconfig testing out there.  ;-)

Or will have when it hits mainline, probably 3.7.

							Thanx, Paul

