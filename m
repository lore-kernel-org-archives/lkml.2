Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1FAGi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:38:28 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45519 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1FAGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:38:25 -0400
Subject: Re: [RFC][PATCH] timers: Make alarmtimer depend on CONFIG_RTC_CLASS
From: John Stultz <john.stultz@linaro.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        tglx@linutronix.de, arnd@arndb.de, peterz@infradead.org,
        toralf.foerster@gmx.de
In-Reply-To: <1306666131-6161-1-git-send-email-richard@nod.at>
References: <1306666131-6161-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 23:38:16 -0700
Message-ID: <1306910297.3359.49.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 12:48 +0200, Richard Weinberger wrote:
> The alarmtimer interface makes IMHO only sense when a RTC device
> is available.
> On systems with !CONFIG_RTC_CLASS (like UML) the warning
> "Kernel not built with RTC support, ALARM timers will not wake from suspend"
> is annoying.

Yea. 

The tradeoff with this patch is that applications that use
CLOCK_REALTIME_ALARM or CLOCK_BOOTTIME_ALARM will then get -EINVAL.

I'm mixed here, since we probably want to communicate to the application
that the alarm timers aren't going to wake us up, but also I suspect
most applications won't handle the -EINVAL properly, so I had allowed
for the clockids to still work as long as we didn't suspend.

I'm leaning more towards just returning EINVAL as you suggest, since
really the functionality isn't there. But I'm thinking possibly doing so
if no RTCs are detected at runtime (rather then using all the ifdefs you
do).

Thoughts from anyone else?

thanks
-john


