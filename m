Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0EKRY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:24:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63486 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0EKRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:24:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188RRN1QrK8zPyBD0oye3XV
Date: Tue, 11 May 2010 10:24:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100511172442.GB13931@atomide.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
 <87632vhbs8.fsf@deeprootsystems.com>
 <201005102225.52431.rjw@sisk.pl>
 <20100511161227.GD13600@atomide.com>
 <20100511161448.GA16148@srcf.ucam.org>
 <20100511163632.GE13600@atomide.com>
 <20100511164554.GA17016@srcf.ucam.org>
 <20100511165821.GA13931@atomide.com>
 <20100511170348.GA17443@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511170348.GA17443@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100511 09:59]:
> On Tue, May 11, 2010 at 09:58:21AM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100511 09:41]:
> > > Yes. You still need suspend blocks.
> > 
> > Maybe not if echo opportunistic > /sys/power/policy gets cleared by
> > the kernel if the kernel idle loop can't make it. That means something
> > has blocked the suspend attempt in a driver for example. The system
> > keeps running, and the userspace can deal with the situation.
> 
> So an event arrives just as userspace does this write. How do you avoid 
> the race? Plausible answers mostly appear to end up looking like suspend 
> blockers.

Assuming you attempt suspend in a custom pm_idle function, any driver
handling the event can fail the suspend attempt.

And that would clear the opportunistic suspend flag. And the userspace
would be still running and could handle the event. And when the userspace
is done, it can again echo opportunistic > /sys/power/policy.

For the failed suspend path in the kernel, currently the kernel would
unwind back all the drivers because of the failed driver, but that path
should be possible to optimize.

Regards,

Tony
