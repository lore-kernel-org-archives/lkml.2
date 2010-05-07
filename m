Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab0EGCGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:06:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0EGCGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:06:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8DdtLJeLC/rCr7ofyH9++
Date: Thu, 6 May 2010 19:05:41 -0700
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
Message-ID: <20100507020541.GH30928@atomide.com>
References: <20100505234755.GI29604@atomide.com>
 <20100506134015.GA23426@srcf.ucam.org>
 <20100506170151.GA30928@atomide.com>
 <20100506170956.GA28104@srcf.ucam.org>
 <20100506171453.GC30928@atomide.com>
 <20100506172201.GA28578@srcf.ucam.org>
 <20100506173807.GD30928@atomide.com>
 <20100506174331.GA29103@srcf.ucam.org>
 <20100506183335.GE30928@atomide.com>
 <20100506184418.GA30669@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506184418.GA30669@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100506 11:39]:
> On Thu, May 06, 2010 at 11:33:35AM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100506 10:39]:
> > > On Thu, May 06, 2010 at 10:38:08AM -0700, Tony Lindgren wrote:
> > > 
> > > > If your userspace keeps polling and has runaway timers, then you
> > > > could suspend it's parent process to idle the system?
> > > 
> > > If your userspace is suspended, how does it process the events that 
> > > generated a system wakeup? If we had a good answer to that then suspend 
> > > blockers would be much less necessary.
> > 
> > Well if your hardware runs off-while-idle or even just
> > retention-while-idle, then the basic shell works just fine waking up
> > every few seconds or so.
> 
> And the untrusted userspace code that's waiting for a network packet? 
> Adding a few seconds of latency isn't an option here.

Hmm well hitting retention and wake you can basically do between
jiffies. Hitting off mode in idle has way longer latencies,
but still in few hundred milliseconds or so, not seconds.

And cpuidle pretty much takes care of hitting the desired C state
for you. This setup is totally working on Nokia N900 for example,
it's hitting off modes in idle and running all the time, it never
suspends.

Regards,

Tony
