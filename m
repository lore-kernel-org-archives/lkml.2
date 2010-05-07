Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0EGSCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:02:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62085 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab0EGSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:02:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18z6wmMlskfpA/7ZEDd23sm
Date: Fri, 7 May 2010 11:01:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507180152.GH387@atomide.com>
References: <20100506171453.GC30928@atomide.com>
 <20100506172201.GA28578@srcf.ucam.org>
 <20100506173807.GD30928@atomide.com>
 <20100506174331.GA29103@srcf.ucam.org>
 <20100506183335.GE30928@atomide.com>
 <20100506184418.GA30669@srcf.ucam.org>
 <20100507020541.GH30928@atomide.com>
 <20100507171218.GA23142@srcf.ucam.org>
 <20100507173549.GF387@atomide.com>
 <20100507175025.GA23952@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507175025.GA23952@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 10:46]:
> On Fri, May 07, 2010 at 10:35:49AM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100507 10:08]:
> > > The situation is this. You've frozen most of your userspace because you 
> > > don't trust the applications. One of those applications has an open 
> > > network socket, and policy indicates that receiving a network packet 
> > > should generate a wakeup, allow the userspace application to handle the 
> > > packet and then return to sleep. What mechanism do you use to do that?
> > 
> > I think the ideal way of doing this would be to have the system running
> > and hitting some deeper idle states using cpuidle. Then fix the apps
> > so timers don't wake up the system too often. Then everything would
> > just run in a normal way.
> 
> Effective power management in the face of real-world applications is a 
> reasonable usecase.

Sure there's no easy solution to misbehaving apps.

> > For the misbehaving stopped apps, maybe they could be woken
> > to deal with the incoming network data with sysfs_notify?
> 
> How would that work? Have the kernel send a sysfs_notify on every netwrk 
> packet and have a monitor app listen for it and unfreeze the rest of 
> userspace if it's frozen? That sounds expensive.

Yeah maybe there are better ways of dealing with this.

Maybe deferred timers would help some so all the apps could
be allowed to run until some power management policy decides
to suspend the whole device.

Regards,

Tony
