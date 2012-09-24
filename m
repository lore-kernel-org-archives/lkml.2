Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab2IXWAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:00:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57448 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2IXWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:00:44 -0400
Date: Mon, 24 Sep 2012 15:00:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120924220023.GG2477@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com>
 <20120921212054.GE2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com>
 <20120922000537.GH2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221813330.10663@utopia.booyaka.com>
 <20120922195253.GD2934@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209222214120.22590@utopia.booyaka.com>
 <20120922231733.GI2934@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209242142490.4521@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209242142490.4521@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092422-2398-0000-0000-00000B5D1C2E
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00176988; UDB=6.00040076; UTC=2012-09-24
 22:00:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 09:54:00PM +0000, Paul Walmsley wrote:
> On Sat, 22 Sep 2012, Paul E. McKenney wrote:
> 
> > On Sat, Sep 22, 2012 at 10:20:19PM +0000, Paul Walmsley wrote:
> > > On Sat, 22 Sep 2012, Paul E. McKenney wrote:
> > >
> > > > This thing has been in the kernel since about 2004, not sure why you 
> > > > didn't hit it earlier.
> > > 
> > > One other data point in that regard - noticed the warnings don't appear 
> > > when the board is booted with:
> > > 
> > > commit 4fa3b6cb1bc8c14b81b4c8ffdfd3f2500a7e9367
> > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Date:   Tue Jun 5 15:53:53 2012 -0700
> > > 
> > >     rcu: Fix qlen_lazy breakage
> > 
> > You lost me on this one.  This is already in mainline, so if you were
> > using (say) 3.6-rc6, you would already have this commit applied.
> 
> If I check out a kernel at this commit 
> 4fa3b6cb1bc8c14b81b4c8ffdfd3f2500a7e9367 + the 
> zero-callback-in-tickless-idle diagnostic patch, build and boot it, then 
> the stall warnings don't appear (in 25 minutes of testing).
> 
> Messages from the diagnostic patch indicate that the kernel is entering 
> idle during a grace period with no RCU callbacks, though.
> 
> This is not a big deal and does not need any further attention.  Just 
> wanted to place a time boundary on the point when these messages started 
> appearing.  (It is unlikely to be an optimal bound: i.e., there are 
> probably later commits where the warnings also don't appear.)

Ah, got it, thank you!

							Thanx, Paul

