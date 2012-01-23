Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2AWVBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:01:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab2AWVBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:01:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Date: Mon, 23 Jan 2012 22:04:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Simon Glass <sjg@chromium.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-serial@vger.kernel.org
References: <1326826563-32215-1-git-send-email-sjg@chromium.org> <201201210049.35254.rjw@sisk.pl> <20120123164511.GE2434@linux.vnet.ibm.com>
In-Reply-To: <20120123164511.GE2434@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201232204.35738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 23, 2012, Paul E. McKenney wrote:
> On Sat, Jan 21, 2012 at 12:49:35AM +0100, Rafael J. Wysocki wrote:
> > On Friday, January 20, 2012, Paul E. McKenney wrote:
> > > On Fri, Jan 20, 2012 at 01:03:34AM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday, January 19, 2012, Paul E. McKenney wrote:
> > > > > On Thu, Jan 19, 2012 at 01:02:58AM +0100, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, January 18, 2012, Paul E. McKenney wrote:
> > > > > > > On Wed, Jan 18, 2012 at 02:15:59PM -0800, Simon Glass wrote:
> > > > [...] 
> > > > > > Yes, you can, but then I'd say it's not necessary for user space to
> > > > > > be able to carry that out in a tight loop.  So, it seems, alternatively,
> > > > > > we could make that loop a bit less tight, e.g. by adding an arbitrary
> > > > > > sleep to the user space interface for the "disable" case.
> > > > > 
> > > > > Good point, that would work just as well and be simpler.
> > > > 
> > > > Thanks for the confirmation! :-)
> > > > 
> > > > By the way, I wonder, would it help to add synchronize_rcu() to
> > > > wakeup_source_add() too?  Then, even if device_wakeup_enable() and
> > > > device_wakeup_disable() are executed in a tight loop for the same
> > > > device, the list_add/list_del operations will always happen in
> > > > different RCU cycles (or at least it seems so).
> > > 
> > > I cannot immediately see how adding a synchronize_rcu() to
> > > wakeup_source_add() would help anything.  You only need to wait for a
> > > grace period on removal, not (normally) on addition.  The single grace
> > > period during removal will catch up all other asynchronous RCU grace
> > > period requests on that CPU.
> > > 
> > > Or am I missing your point?
> > 
> > Well, I was thinking about the failure scenario you mentioned where
> > executing enable/disable in a tight loop might exhaust system memory
> > (if I understood it correctly).
> 
> Ah, got it.  If they are executing this in a tight loop, there will be
> little difference between doing one synchronize_rcu() per pass through
> the loop or doing two.  So we should be just fine with the single instance
> of synchronize_rcu() per loop.

Good! :-)

Thanks a lot,
Rafael
