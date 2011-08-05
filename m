Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1HEUVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:21:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35086 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755514Ab1HEUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:21:36 -0400
Date: Fri, 5 Aug 2011 16:21:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesper Juhl <jj@chaosbits.net>, Len Brown <len.brown@intel.com>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
In-Reply-To: <201108052213.40969.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1108051617430.2055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:

> > > I don't know how to fix it yet, but I think I know what the problem is.
> > > Namely, a runtime suspend of the Ethernet adapter as occured in parallel with
> > > the system-wide suspend and they clashed.  The runtime suspend has probably
> > > been provoked by detaching the Ethernet cable from the box.
> > 
> > For them to clash in that way would mean that the PM workqueue didn't
> > get frozen.
> 
> Not necessarily, I think.  It's sufficient that system suspend is started
> while the runtime PM operation is in progress.

How so?  The system suspend doesn't call down to the subsystems or 
drivers until after all the threads are frozen.  In this case the stack 
dump shows that the runtime PM operation was asynchronous, running in a 
workqueue thread (pm_runtime_work is one of the routines near the end 
of the stack dump).  The thread wouldn't have frozen until the runtime 
PM operation was complete.

Alan Stern

