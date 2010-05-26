Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0EZOi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:38:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45856 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274Ab0EZOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:38:53 -0400
Date: Wed, 26 May 2010 10:38:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Mickler <florian@mickler.org>
cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       <Paul@smtp1.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100526151945.1b3813ac@schatten.dmk.lab>
Message-ID: <Pine.LNX.4.44L0.1005261033440.1961-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Florian Mickler wrote:

> I don't think that the in-kernel suspend block is a bad idea. 
> 
> You could probably use the suspend-blockers unconditionally in the
> suspend framework to indicate if a suspend is possible or not.

That's not how it works.  Drivers aren't supposed to abort
unconditional suspend -- not without a really good reason (for example,
the device received a wakeup event before it was fully suspended).  In
short, suspends should be considered to be _always_ possible.

> Regardless of opportunistic suspend or not. This way, you don't have to
> try-and-fail on a suspend request and thus making suspending
> potentially more robust or allowing for a "suspend as soon as
> possible" semantic (which is probably a good idea, if you have to grab
> your laptop in a hurry to get away).

That's different.  Suspend blockers could block (not abort!) regular 
suspends, just as they do opportunistic suspends.

But why should they?  I mean, if userspace wants to initiate a suspend
that is capable of being blocked by a kernel suspend blocker, then all
it has to do is initiate an opportunistic suspend instead of a normal
suspend.

Alan Stern

