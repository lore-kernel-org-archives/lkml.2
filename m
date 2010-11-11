Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0KKSby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:31:54 -0500
Received: from relais.videotron.ca ([24.201.245.36]:20236 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0KKSbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:31:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 11 Nov 2010 13:31:52 -0500 (EST)
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
In-reply-to: <alpine.LFD.2.00.1011111203140.2900@localhost6.localdomain6>
Message-id: <alpine.LFD.2.00.1011111330170.13911@xanadu.home>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
 <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6>
 <4CDBC60F.8070905@stericsson.com>
 <alpine.LFD.2.00.1011111203140.2900@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Thomas Gleixner wrote:

> On Thu, 11 Nov 2010, Linus Walleij wrote:
> 
> > Thomas Gleixner wrote:
> > 
> > > There is only one caveat. When nohz is on and you sleep longer than 16
> > > seconds then the limitation we have in place does not work anymore, as
> > > it would say that the long sleep time is less than the 63bit
> > > wraparound time. With 32bit clocksource it limits the sleep correclty
> > > to avoid the clocksource wrap issue.
> > 
> > Hm! So the .mask has that side effect (as I suspected), and with
> > this the sleep will be limited to what time you can get into 63 bits
> > (2200 years). And we sure want NOHZ...
> > 
> > But if I complement the solution with the keepwarm() timer from
> > Orion doing just a dummy read() on the clocksource every say 15 secs
> > it will work even if the system sleeps for so long.
> 
> Well, you don't need the keepwarm() timer, if you just call
> sched_clock() in the idle wakeup path, so the magic in the NOHZ code
> will ensure that you reread the thing timely.

You still have to make sure you get out of idle before 16 secs has 
passed.


Nicolas
