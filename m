Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2JQPON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:14:13 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33618 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab2JQPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:14:11 -0400
Message-ID: <1350486837.6414.3.camel@lambeau>
Subject: Re: [PATCH RFC V2 0/5] Separate consigned (expected steal) from
 steal time.
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Wed, 17 Oct 2012 10:13:57 -0500
In-Reply-To: <507EE77D.6010906@parallels.com>
References: <20121017022249.16949.2775.stgit@lambeau>
	 <507EE77D.6010906@parallels.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12101715-9264-0000-0000-00000283281B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 21:14 +0400, Glauber Costa wrote:
> On 10/17/2012 06:23 AM, Michael Wolf wrote:
> > In the case of where you have a system that is running in a
> > capped or overcommitted environment the user may see steal time
> > being reported in accounting tools such as top or vmstat.  This can
> > cause confusion for the end user.  To ease the confusion this patch set
> > adds the idea of consigned (expected steal) time.  The host will separate
> > the consigned time from the steal time.  The consignment limit passed to the
> > host will be the amount of steal time expected within a fixed period of
> > time.  Any other steal time accruing during that period will show as the
> > traditional steal time.
> > 
> > TODO:
> > * Change native_clock to take params and not return a value
> > * Change update_rq_clock_task
> > 
> > Changes from V1:
> > * Removed the steal time allowed percentage from the guest
> > * Moved the separation of consigned (expected steal) and steal time to the
> >   host.
> > * No longer include a sysctl interface.
> > 
> 
> You are showing this in the guest somewhere, but tools like top will
> still not show it. So for quite a while, it achieves nothing.
> 
> Of course this is a barrier that any new statistic has to go through. So
> while annoying, this is per-se ultimately not a blocker.
> 
> What I still fail to see, is how this is useful information to be shown
> in the guest. Honestly, if I'm in a guest VM or container, any time
> during which I am not running is time I lost. It doesn't matter if this
> was expected or not. This still seems to me as a host-side problem, to
> be solved entirely by tooling.
> 

What tools like top and vmstat will show is altered.  When I put time in
the consign bucket it does not show up in steal.  So now as long as the
system is performing as expected the user will see 100% and 0% steal.  I
added the consign field to /proc/stat so that all time accrued in the
period is accounted for and also for debugging purposes.  The user wont
care about consign and will not see it.  

