Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2FUIXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:23:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36816 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753540Ab2FUIXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:23:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+2NL8255i2IIMGDw4ogagfzi5URwGEbdP00hpUXA
	2SBZQgeGIieHIO
Message-ID: <1340266982.29752.37.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 10:23:02 +0200
In-Reply-To: <20120621075428.GE31797@beaver>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net>
	 <20120621075428.GE31797@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:54 +0400, Alexey Vlasov wrote: 
> On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> > 
> > kernel/cgroup.c::cgroup_attach_task()
> > {
> > ...
> > 	synchronize_rcu();
> > ...
> > }
> 
> So nothing can be done here? (I mean if only I knew how to fix it I
> wouldn't ask about it ;)

Sure, kill the obnoxious thing, it's sitting right in the middle of the
userspace interface.

I banged on it a while back (wrt explosive android patches), extracted
RCU from the userspace interface.  It seemed to work great, much faster,
couldn't make it explode.  I wouldn't bet anything I wasn't willing to
immediately part with that the result was really really safe though ;-)

-Mike

