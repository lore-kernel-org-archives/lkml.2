Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0FYU6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:58:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47229 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751187Ab0FYU6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:58:00 -0400
Date: Fri, 25 Jun 2010 16:57:57 -0400 (EDT)
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
In-Reply-To: <201006252237.50584.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006251654470.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Rafael J. Wysocki wrote:

> > > You seem to be referring to the PM workqueue specifically.  Perhaps it would be
> > > better to special-case it and stop it by adding a barrier work during suspend
> > > instead of just freezing?  Then, it wouldn't need to be singlethread any more.
> > 
> > The barrier work would have to be queued to each CPU's thread.  That
> > would be okay.
> 
> I guess we should stop the PM workqueue after the freezing of tasks, shouldn't we?

Yes.  The exact spot probably doesn't matter; that's as good as any.

> > Hmm, it looks like wait_event_freezable() and
> > wait_event_freezable_timeout() could use similar changes: If the
> > condition is true then they shouldn't try to freeze the caller.
> 
> Yes, but that should be a separate patch IMHO.

Agreed.

Alan Stern

