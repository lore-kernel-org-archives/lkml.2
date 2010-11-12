Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0KLKip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:38:45 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:53004 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab0KLKio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:38:44 -0500
Message-ID: <4CDD18F9.5090005@stericsson.com>
Date: Fri, 12 Nov 2010 11:37:45 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        john stultz <johnstul@us.ibm.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com> <20101112095739.GH18358@pengutronix.de> <4CDD120A.2050401@stericsson.com> <alpine.LFD.2.00.1011121130350.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011121130350.2900@localhost6.localdomain6>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 12 Nov 2010, Linus Walleij wrote:
>> Uwe Kleine-König wrote:
>>
>>> Instead of implementing sched_clock for each architecture seperatly,
>>> wouldn't it be nice to have a generic sched_clock that uses the
>>> architecture's clocksource?  I tried to implement that some time ago,
>>> but tglx shoot it down because of locking problems.
>> I was and still am a big fan of this approach, I am willing to help
>> testing it if you want to dust off this patch set...
> 
> sched_clock is not necessarily the same as the current clocksource.

IIRC Uwe:s approach was that if and only if you would want to use
the clocksource for sched_clock() you provide a special flag on
the clocksource, and it will be attempted to be used for sched_clock().

Incidentally the dual use of a single free-running timer as both
single clocksource and sched_clock() baseline seem to creep up in
a lot of embedded platforms...

Yours,
Linus Walleij
