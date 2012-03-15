Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281Ab2COSXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:23:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48512 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2COSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:23:31 -0400
Date: Thu, 15 Mar 2012 11:23:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
Message-ID: <20120315182314.GK2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120314002414.GA21561@linux.vnet.ibm.com>
 <1331717099.5752.15.camel@marge.simpson.net>
 <1331728841.7465.7.camel@marge.simpson.net>
 <20120314130801.GA11722@sgi.com>
 <20120314151717.GA2435@linux.vnet.ibm.com>
 <20120314165657.GA19117@linux.vnet.ibm.com>
 <20120315175857.GA8705@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315175857.GA8705@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031518-5518-0000-0000-000002FA7D8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:58:57PM -0500, Dimitri Sivanich wrote:
> On Wed, Mar 14, 2012 at 09:56:57AM -0700, Paul E. McKenney wrote:
> > On Wed, Mar 14, 2012 at 08:17:17AM -0700, Paul E. McKenney wrote:
> > > On Wed, Mar 14, 2012 at 08:08:01AM -0500, Dimitri Sivanich wrote:
> > > > On Wed, Mar 14, 2012 at 01:40:41PM +0100, Mike Galbraith wrote:
> > > > > On Wed, 2012-03-14 at 10:24 +0100, Mike Galbraith wrote: 
> > > > > > On Tue, 2012-03-13 at 17:24 -0700, Paul E. McKenney wrote: 
> > > > > > > The following builds, but is only very lightly tested.  Probably full
> > > > > > > of bug, especially when exercising CPU hotplug.
> > > > > > 
> > > > > > You didn't say RFT, but...
> > > > > > 
> > > > > > To beat on this in a rotund 3.0 kernel, the equivalent patch would be
> > > > > > the below?  My box may well answer that before you can.. hope not ;-)
> > > > > 
> > > > > (Darn, it did.  Box says boot stall with virgin patch in tip too though.
> > > > > Wedging it straight into 3.0 was perhaps a tad premature;)
> > > > 
> > > > I saw the same thing with 3.3.0-rc7+ and virgin patch on UV.  Boots fine without the patch.
> > > 
> > > Right...  Bozo here forgot to set the kernel parameters for large-system
> > > emulation during testing.  Apologies for the busted patch, will fix.
> > > 
> > > And thank you both for the testing!!!
> > > 
> > > Hey, at least I labeled it "RFC".  ;-)
> > 
> > Does the following work better?  It does pass my fake-big-system tests
> > (more testing in the works).
> 
> This one stalls for me at the same place the other one did.  Once again,
> if I remove the patch and rebuild, it boots just fine.
> 
> Is there some debug/trace information that you would like me to provide?

Very strange.

Could you please send your dmesg and .config?

							Thanx, Paul

