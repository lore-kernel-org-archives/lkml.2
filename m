Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0FYUj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:39:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0FYUjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:39:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Fri, 25 Jun 2010 22:37:50 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006251056430.1604-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006251056430.1604-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006252237.50584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 25, 2010, Alan Stern wrote:
> On Fri, 25 Jun 2010, Rafael J. Wysocki wrote:
> 
> > > That's not the point.  If a wakeup handler queues a work item (for
> > > example, by calling pm_request_resume) then it wouldn't need to guess a
> > > timeout.  The work item would be guaranteed to run before the system
> > > could suspend again.
> > 
> > You seem to be referring to the PM workqueue specifically.  Perhaps it would be
> > better to special-case it and stop it by adding a barrier work during suspend
> > instead of just freezing?  Then, it wouldn't need to be singlethread any more.
> 
> The barrier work would have to be queued to each CPU's thread.  That
> would be okay.

I guess we should stop the PM workqueue after the freezing of tasks, shouldn't we?

> Hmm, it looks like wait_event_freezable() and
> wait_event_freezable_timeout() could use similar changes: If the
> condition is true then they shouldn't try to freeze the caller.

Yes, but that should be a separate patch IMHO.

Rafael
