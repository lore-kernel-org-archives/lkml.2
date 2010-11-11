Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0KKKc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:32:29 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58607 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242Ab0KKKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:32:27 -0500
Message-ID: <4CDBC60F.8070905@stericsson.com>
Date: Thu, 11 Nov 2010 11:31:43 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@google.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011111054010.2900@localhost6.localdomain6>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> There is only one caveat. When nohz is on and you sleep longer than 16
> seconds then the limitation we have in place does not work anymore, as
> it would say that the long sleep time is less than the 63bit
> wraparound time. With 32bit clocksource it limits the sleep correclty
> to avoid the clocksource wrap issue.

Hm! So the .mask has that side effect (as I suspected), and with
this the sleep will be limited to what time you can get into 63 bits
(2200 years). And we sure want NOHZ...

But if I complement the solution with the keepwarm() timer from
Orion doing just a dummy read() on the clocksource every say 15 secs
it will work even if the system sleeps for so long.

> Aside of that you are trading a bit less source code with extra code
> in the clock read() function, which is called pretty frequently.

Hm, yeah. I would have to go to metrics but it's O(n)
is it not? Shouldn't hurt a high-frequency SMP system
I believe.

Yours,
Linus Walleij
