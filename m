Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2EGDsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:48:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50009 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2EGDsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:48:09 -0400
Date: Sun, 6 May 2012 20:47:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: possible circular locking dependency
Message-ID: <20120507034744.GA3141@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120503200259.GA3524@swordfish.minsk.epam.com>
 <4FA63C82.7030309@redhat.com>
 <20120506164209.GK2470@linux.vnet.ibm.com>
 <20120506203439.GB3633@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506203439.GB3633@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050703-8974-0000-0000-000008D62A72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 11:34:39PM +0300, Sergey Senozhatsky wrote:
> On (05/06/12 09:42), Paul E. McKenney wrote:
> > On Sun, May 06, 2012 at 11:55:30AM +0300, Avi Kivity wrote:
> > > On 05/03/2012 11:02 PM, Sergey Senozhatsky wrote:
> > > > Hello,
> > > > 3.4-rc5
> > > 
> > > Whoa.
> > > 
> > > Looks like inconsistent locking between cpufreq and
> > > synchronize_srcu_expedited().  kvm triggered this because it is one of
> > > the few users of synchronize_srcu_expedited(), but I don't think it is
> > > doing anything wrong directly.
> > > 
> > > Dave, Paul?
> > 
> > SRCU hasn't changed much in mainline for quite some time.  Holding
> > the hotplug mutex across a synchronize_srcu() is a bad idea, though.
> > 
> > However, there is a reworked implementation (courtesy of Lai Jiangshan)
> > in -rcu that does not acquire the hotplug mutex.  Could you try that out?
> >
> 
> Paul, should I try solely -rcu or there are several commits to pick up and apply
> on top of -linus tree?

If you want the smallest possible change, take the rcu/srcu branch of -rcu.
If you want the works, take the rcu/next branch of -rcu.

You can find -rcu at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

								Thanx, Paul

