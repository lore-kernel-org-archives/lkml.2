Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab0E0SJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:09:26 -0400
Received: from www.tglx.de ([62.245.132.106]:37670 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211Ab0E0SJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:09:17 -0400
Date: Thu, 27 May 2010 20:08:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <Pine.LNX.4.44L0.1005271334560.3239-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1005272006560.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271334560.3239-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Stern wrote:

> On Thu, 27 May 2010, Thomas Gleixner wrote:
> 
> > Crap. Stop beating on those lost wakeup events. If we lose them then
> > the drivers are broken and do not handle the switch over correctly. Or
> > the suspend mechanism is broken as it does not evaluate the system
> > state correctly. Blockers are just papering over that w/o tackling the
> > real problem.
> 
> That's the point -- suspend does not evaluate the system state 
> correctly because it doesn't have the necessary information.  Suspend 
> blockers are a way of providing it that information.  They don't paper 
> over the problem; they solve it.

Nonsense. The system state is well defined when a event is pending and
we just have to say good bye to the idea that forced suspend is a good
solution. It's not as it does not guarantee the event processing in
badly written apps and it does move the power consumption to a later
point in time for those apps which acquire/drop the blockers.

Thanks,

	tglx
