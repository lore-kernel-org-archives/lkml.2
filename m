Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0EFSg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:36:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60822 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0EFSgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:36:25 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19H81LY2zUkk2MqIFgb8DTH
Date: Thu, 6 May 2010 11:36:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100506183605.GF30928@atomide.com>
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <20100506134015.GA23426@srcf.ucam.org>
 <20100506170151.GA30928@atomide.com>
 <20100506170956.GA28104@srcf.ucam.org>
 <20100506171453.GC30928@atomide.com>
 <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker <dwalker@fifo99.com> [100506 10:30]:
> On Thu, 2010-05-06 at 10:14 -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100506 10:05]:
> > > On Thu, May 06, 2010 at 10:01:51AM -0700, Tony Lindgren wrote:
> > > 
> > > > Or are you suspending constantly, tens of times per minute even if
> > > > there's no user activity?
> > > 
> > > In this case you'd be repeatedly trying to suspend until the modem 
> > > driver stopped blocking it. It's pretty much a waste.
> > 
> > But then the userspace knows you're getting data from the modem, and
> > it can kick some inactivity timer that determines when to try to
> > suspend next.
> 
> If the idle thread was doing the suspending then the inactivity timer by
> it's self could block suspend. As long as the idle thread was setup to
> check for timers. I'm sure that _isn't_ the point your trying to make.
> It just makes gobs more sense to me that the idle thread does the
> suspending .. Your idle, so depending on how long your idle then you
> suspend.

The alternative logic I'm suggesting is get the GUI into idle mode as
soon as possible, then limp along with off-while-idle or
retention-while-idle until some timer expires, then suspend the whole
device.

Tony
