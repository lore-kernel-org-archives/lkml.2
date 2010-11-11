Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0KKTAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:00:42 -0500
Received: from www.tglx.de ([62.245.132.106]:34484 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0KKTAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:00:41 -0500
Date: Thu, 11 Nov 2010 20:00:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nico@fluxnic.net>
cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@google.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-Reply-To: <alpine.LFD.2.00.1011111330170.13911@xanadu.home>
Message-ID: <alpine.LFD.2.00.1011111958460.2900@localhost6.localdomain6>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6> <4CDBC60F.8070905@stericsson.com> <alpine.LFD.2.00.1011111203140.2900@localhost6.localdomain6>
 <alpine.LFD.2.00.1011111330170.13911@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Nicolas Pitre wrote:
> On Thu, 11 Nov 2010, Thomas Gleixner wrote:
> > Well, you don't need the keepwarm() timer, if you just call
> > sched_clock() in the idle wakeup path, so the magic in the NOHZ code
> > will ensure that you reread the thing timely.
> 
> You still have to make sure you get out of idle before 16 secs has 
> passed.

No, I meant to put it into the idle loop, right after mach_idle() or
whatever is called to put the CPU into deep power sleep. The
clockevents core code makes sure that you get interrupted in time.

Thanks,

	tglx
