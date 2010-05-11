Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0EKQ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:58:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61084 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0EKQ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:58:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+htPZe4XUuEBvNCLUKiq6T
Date: Tue, 11 May 2010 09:58:21 -0700
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
Message-ID: <20100511165821.GA13931@atomide.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
 <87632vhbs8.fsf@deeprootsystems.com>
 <201005102225.52431.rjw@sisk.pl>
 <20100511161227.GD13600@atomide.com>
 <20100511161448.GA16148@srcf.ucam.org>
 <20100511163632.GE13600@atomide.com>
 <20100511164554.GA17016@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511164554.GA17016@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100511 09:41]:
> On Tue, May 11, 2010 at 09:36:33AM -0700, Tony Lindgren wrote:
> > OK, so can the suspend blocker then become just:
> > 
> > # Block suspend while idle, system stays running
> > # echo default > /sys/power/policy
> > 
> > and the when it's OK to suspend:
> > 
> > # Allow suspend while idle, system suspends when it hits kernel idle loop
> > # echo opportunistic > /sys/power/policy
> > 
> > or do you still need something more to ensure the data gets into your
> > app and be handled?
> 
> Yes. You still need suspend blocks.

Maybe not if echo opportunistic > /sys/power/policy gets cleared by
the kernel if the kernel idle loop can't make it. That means something
has blocked the suspend attempt in a driver for example. The system
keeps running, and the userspace can deal with the situation.
 
> > The part I really don't like is the idea of patching all over the drivers
> > and userspace for the wakelocks/suspendblocks.
> 
> I don't like the idea either, but given that nobody has actually 
> provided any other ideas that would actually work then I don't think 
> we've got a great deal of choice.

If the opportunistic kernel flag is one time attempt only, then you
could take care of the wakelock/suspendblock handling in the userspace
completely. And once the userspace wakelock/suspendblock is cleared,
the userspace can again echo opportunistic > /sys/power/policy.

Regards,

Tony
