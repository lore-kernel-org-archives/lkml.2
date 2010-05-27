Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0E0RAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:00:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40060 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932443Ab0E0RAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:00:40 -0400
Date: Thu, 27 May 2010 13:00:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       <Paul@smtp1.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Thomas Gleixner wrote:

> The whole notion of treating suspend to RAM any different than a plain
> idle C-State is wrong. It's not different at all. You just use a
> different mechanism which has longer takedown and wakeup latencies and
> requires to shut down stuff and setup extra wakeup sources.

This is where you are wrong.  Maybe not wrong in principle, but wrong 
in practice -- the kernel's present suspend-to-RAM (or just "suspend") 
implementation is _very_ different from C-states (or just "idle").

The primary difference is that the kernel can be forced into suspend
even when the system isn't idle.  In particular, it may be in the
middle of processing a potential wakeup event -- and the current design
gives the PM core no way to know if that is so.  This is a weakness
that in-kernel suspend blockers fix.

With C-states this can't happen.  If the CPU goes into a deeper C-state 
then ipso facto it isn't busy processing anything, much less a wakeup 
event.

Now maybe this difference is a bad thing, and the whole PM 
suspend/hibernate infrastructure should be rewritten.  But the fact, 
remains, that's how it works now.  And it can't be changed easily or 
quickly.

Alan Stern

