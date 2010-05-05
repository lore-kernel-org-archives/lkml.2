Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0EEXsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:48:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54852 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0EEXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:48:09 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NQ0f8yTj+OY2V7OGvHiK5
Date: Wed, 5 May 2010 16:47:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Brian Swetland <swetland@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100505234755.GI29604@atomide.com>
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Brian Swetland <swetland@google.com> [100505 14:34]:
> On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >>
> >> Oh, like tell the modem that user mode has handled the ring event and
> >> its ok to un-block?
> >
> > No, that's not how it works.  It would go like this:
> >
> >        The modem IRQ handler queues its event to the input subsystem.
> >        As it does so the input subsystem enables a suspend blocker,
> >        causing the system to stay awake after the IRQ is done.

How about instead the modem driver fails to suspend until it's done?

Each driver could have a suspend_policy sysfs entry with options such
as [ forced | safe ]. The default would be forced. Forced would
be the current behaviour, while safe would refuse suspend until the
driver is done processing.

> >        The user program enables its own suspend blocker before reading
> >        the input queue.  When the queue is empty, the input subsystem
> >        releases its suspend blocker.

And also the input layer could refuse to suspend until it's done.

> >        When the user program finishes processing the event, it
> >        releases its suspend blocker.  Now the system can go back to
> >        sleep.

And here the user space just tries to suspend again when it's done?
It's not like you're trying to suspend all the time, so it should be
OK to retry a few times.

> > At no point does the user program have to communicate anything to the
> > modem driver, and at no point does it have to do anything out of the
> > ordinary except to enable and disable a suspend blocker.
> 
> Exactly -- and you can use the same style of overlapping suspend
> blockers with other drivers than input, if the input interface is not
> suitable for the particular interaction.

Would the suspend blockers still be needed somewhere in the example
above?

Regards,

Tony
