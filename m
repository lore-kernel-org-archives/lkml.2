Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0FYPJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:09:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751113Ab0FYPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:09:51 -0400
Date: Fri, 25 Jun 2010 11:09:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006250106.41855.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006251056430.1604-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Rafael J. Wysocki wrote:

> > That's not the point.  If a wakeup handler queues a work item (for
> > example, by calling pm_request_resume) then it wouldn't need to guess a
> > timeout.  The work item would be guaranteed to run before the system
> > could suspend again.
> 
> You seem to be referring to the PM workqueue specifically.  Perhaps it would be
> better to special-case it and stop it by adding a barrier work during suspend
> instead of just freezing?  Then, it wouldn't need to be singlethread any more.

The barrier work would have to be queued to each CPU's thread.  That
would be okay.

Hmm, it looks like wait_event_freezable() and
wait_event_freezable_timeout() could use similar changes: If the
condition is true then they shouldn't try to freeze the caller.

> Still, I think the timeout is necessary anyway in case the driver simply
> doesn't handle the event and user space needs time to catch up.  Unfortunately,
> the PCI wakeup code doesn't know what happens next in advance.

That could all be handled by the lower driver.  Still, a 100-ms timeout
isn't going to make a significant difference, since a suspend/resume 
cycle will take a comparable length of time.

Alan Stern

