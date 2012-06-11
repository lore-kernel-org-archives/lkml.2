Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2FKSBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:01:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36380 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2FKSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:01:32 -0400
Date: Mon, 11 Jun 2012 11:01:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <mgalbraith@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: rcu: endless stalls
Message-ID: <20120611180112.GD2521@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339409176.7350.26.camel@marge.simpson.net>
 <20120611133953.GI2425@linux.vnet.ibm.com>
 <1339424543.7350.101.camel@marge.simpson.net>
 <1339435214.7358.43.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339435214.7358.43.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061118-2398-0000-0000-00000767C934
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 07:20:14PM +0200, Mike Galbraith wrote:
> On Mon, 2012-06-11 at 16:22 +0200, Mike Galbraith wrote: 
> > On Mon, 2012-06-11 at 06:39 -0700, Paul E. McKenney wrote: 
> > > On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> > > > Greetings,
> > > > 
> > > > I received a report of a 48 core UV box hitting a gripe, taking longer
> > > > than timeout to emit same, so box griped endlessly, forcing reboot.
> > > 
> > > So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?
> > > 
> > > If so, yow!!!
> > 
> > The report was a tad fuzzy on details, but serial console can take a
> > while at low baud rate, and the box was apparently perma-stalled.
> 
> Gee, no wonder it took a while to emit the gripe, there were a few more
> than 48 CPUs actually.. 4048 more to be precise.
> 
> 4096 tasks on 4096 CPUs all hammering wait_lock at once r!pretty.

That would be bad...

BTW, one other thing on the patch -- it needs to use a separate flag,
otherwise there are races with sysfs and panic() updates to the flag.

> 2aa15890 - mm: prevent concurrent unmap_mapping_range() on the same inode

I confess, you lost me on this one.  You believe that this commit is
the cause of the RCU CPU stall warnings?

							Thanx, Paul

