Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2FZSRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:17:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34065 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2FZSR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:17:29 -0400
Date: Tue, 26 Jun 2012 11:06:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Alexey Vlasov <renton@renton.name>, linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120626180620.GK2397@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
 <20120621075428.GE31797@beaver>
 <1340266982.29752.37.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340266982.29752.37.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062618-6148-0000-0000-000007162FC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 10:23:02AM +0200, Mike Galbraith wrote:
> On Thu, 2012-06-21 at 11:54 +0400, Alexey Vlasov wrote: 
> > On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> > > 
> > > kernel/cgroup.c::cgroup_attach_task()
> > > {
> > > ...
> > > 	synchronize_rcu();
> > > ...
> > > }
> > 
> > So nothing can be done here? (I mean if only I knew how to fix it I
> > wouldn't ask about it ;)
> 
> Sure, kill the obnoxious thing, it's sitting right in the middle of the
> userspace interface.
> 
> I banged on it a while back (wrt explosive android patches), extracted
> RCU from the userspace interface.  It seemed to work great, much faster,
> couldn't make it explode.  I wouldn't bet anything I wasn't willing to
> immediately part with that the result was really really safe though ;-)

Or replace it with synchronize_rcu_expedited().  You can "get lucky"
for quite some time removing synchronize_rcu() calls!

							Thanx, Paul

