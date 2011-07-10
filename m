Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1GJRfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 13:35:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40800 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab1GJRft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 13:35:49 -0400
Date: Sun, 10 Jul 2011 10:35:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110710173530.GA16954@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
 <201107072047.14429.kernelmail.jms@gmail.com>
 <20110707195845.GD6014@linux.vnet.ibm.com>
 <201107072147.12751.kernelmail.jms@gmail.com>
 <20110708002903.GI6014@linux.vnet.ibm.com>
 <20110709100900.GB6014@linux.vnet.ibm.com>
 <CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
 <20110710032510.GG6014@linux.vnet.ibm.com>
 <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110710171626.GK6014@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 10:16:26AM -0700, Paul E. McKenney wrote:
> On Sun, Jul 10, 2011 at 05:38:25PM +0100, julie Sullivan wrote:
> > > I added another patch onto the jms.2011.07.07a in the -rcu git tree.
> > > If you get a chance to test it, please let me know how it goes.
> > >
> > >                                                        Thanx, Paul
> > 
> > 
> > Right, adding this commit to the other six:
> > 
> > commit 8a153670878242b8a95213d986f4922111321743
> > 
> >  makes us freeze on boot again.
> 
> Thank you again for the testing!  This one will take some thought...

But maybe not that much thought.  My current guess is that your
configuration is somehow causing some RCU callbacks to be executed
during early boot, and that these callbacks are attempting to use kernel
features that are not yet initialized.  If my guess is correct, then
the reason that enabling RCU_BOOST makes things work is that it prevents
RCU callbacks from executing until after the scheduler is up and running.

So I added another commit to the jms.2011.07.07a branch in the -rcu
git tree.  If my guesses are correct, this will allow your system to
boot, possibly emitting a warning on the way up.  When you get a chance
to try this out, please let me know how it goes.

							Thanx, Paul
