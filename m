Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0E0TTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:19:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34148 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754598Ab0E0TTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:19:40 -0400
Date: Thu, 27 May 2010 15:19:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       <felipe.balbi@nokia.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1274983363.27810.5749.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005271517170.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Peter Zijlstra wrote:

> I still don't see how blocking applications will cause missed wakeups in
> anything but a buggy application at worst, and even those will
> eventually get the event when they unblock.
> 
> What seems to be the confusion?

During forced suspend, applications are block because they are frozen.

When an event occurs, the application is notified somehow.  But it 
can't respond because it is frozen.  Hence the event remains sitting in 
a kernel queue and the system goes ahead and suspends anyway.  The 
application doesn't get thawed until the system wakes up at some 
indefinite time in the future.

Alan Stern

