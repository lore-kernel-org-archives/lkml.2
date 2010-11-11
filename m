Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0KKTTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:19:04 -0500
Received: from relais.videotron.ca ([24.201.245.36]:55587 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0KKTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:19:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 11 Nov 2010 14:19:01 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@google.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-reply-to: <alpine.LFD.2.00.1011111958460.2900@localhost6.localdomain6>
Message-id: <alpine.LFD.2.00.1011111413410.13911@xanadu.home>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
 <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6>
 <4CDBC60F.8070905@stericsson.com>
 <alpine.LFD.2.00.1011111203140.2900@localhost6.localdomain6>
 <alpine.LFD.2.00.1011111330170.13911@xanadu.home>
 <alpine.LFD.2.00.1011111958460.2900@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Thomas Gleixner wrote:

> On Thu, 11 Nov 2010, Nicolas Pitre wrote:
> > On Thu, 11 Nov 2010, Thomas Gleixner wrote:
> > > Well, you don't need the keepwarm() timer, if you just call
> > > sched_clock() in the idle wakeup path, so the magic in the NOHZ code
> > > will ensure that you reread the thing timely.
> > 
> > You still have to make sure you get out of idle before 16 secs has 
> > passed.
> 
> No, I meant to put it into the idle loop, right after mach_idle() or
> whatever is called to put the CPU into deep power sleep. The
> clockevents core code makes sure that you get interrupted in time.

OK, if the clockevents core code takes care of that then fine.

Of course one could claim that the sched_clock() code could be called 
needlessly when frequently entering and leaving idle mode.  That's why 
I've used a simple timer for this purpose so far, which also makes the 
implementation and its algorithm constraint workaround close together.


Nicolas
