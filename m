Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0KKLFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:05:20 -0500
Received: from www.tglx.de ([62.245.132.106]:42315 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab0KKLFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:05:16 -0500
Date: Thu, 11 Nov 2010 12:05:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@google.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
In-Reply-To: <4CDBC60F.8070905@stericsson.com>
Message-ID: <alpine.LFD.2.00.1011111203140.2900@localhost6.localdomain6>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6> <4CDBC60F.8070905@stericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Linus Walleij wrote:

> Thomas Gleixner wrote:
> 
> > There is only one caveat. When nohz is on and you sleep longer than 16
> > seconds then the limitation we have in place does not work anymore, as
> > it would say that the long sleep time is less than the 63bit
> > wraparound time. With 32bit clocksource it limits the sleep correclty
> > to avoid the clocksource wrap issue.
> 
> Hm! So the .mask has that side effect (as I suspected), and with
> this the sleep will be limited to what time you can get into 63 bits
> (2200 years). And we sure want NOHZ...
> 
> But if I complement the solution with the keepwarm() timer from
> Orion doing just a dummy read() on the clocksource every say 15 secs
> it will work even if the system sleeps for so long.

Well, you don't need the keepwarm() timer, if you just call
sched_clock() in the idle wakeup path, so the magic in the NOHZ code
will ensure that you reread the thing timely.

Thanks,

	tglx
