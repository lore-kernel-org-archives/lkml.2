Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0E0Tcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:32:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37945 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756937Ab0E0Tcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:32:53 -0400
Date: Thu, 27 May 2010 15:32:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527202712.181fd172@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.1005271526130.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Cox wrote:

> > Rather than continue going around in circles, let's agree that what the 
> > Android people want is a new version of forced suspend -- not a 
> 
> I don't think this is true. I think that is the root of the problem.

Of course it's true.  Just ask Arve -- he wants opportunistic suspend 
and it _is_ a variant of forced suspend.  Ergo he wants a new type of 
forced suspend.

Maybe that's not what he _ought_ to want.  Nevertheless, there are 
valid reasons for wanting it.

> I don't disagree with the user experience they are trying to create or
> the fact something is needed to make it possible (if it turns out we
> can't already do it).
> 
> Forced suspend is sticking stuff in running state into suspend
> 
> Power management models (such as Thomas ARM box) which we know work are
> 'when nothing is running' into suspend.
> 
> So for me the real question on that side of this specific case is 'how
> do you make sure those tasks are idle when you need them to be'
> 
> QoS ?
> Spanking them from user space ?
> Drivers enforcing policy elements by blocking tasks ?

Currently we use the freezer.  But it is a blunt tool -- it freezes 
every user process.  Also, it doesn't actually make processes 
unrunnable; it just arranges things so that when they do run, they 
immediately put themselves back to sleep.

And the forced-suspend design relies on the fact that processes remain 
frozen throughout.  If we leave some processes unfrozen and one of them 
somehow becomes runnable, that means we have to abort the forced 
suspend before the process is allowed to run.

Alan Stern

