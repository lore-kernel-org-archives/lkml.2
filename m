Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1FAMXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:23:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab1FAMXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:23:48 -0400
Subject: Re: [RFC][PATCH] timers: Make alarmtimer depend on CONFIG_RTC_CLASS
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de, arnd@arndb.de,
        toralf.foerster@gmx.de
In-Reply-To: <1306910297.3359.49.camel@work-vm>
References: <1306666131-6161-1-git-send-email-richard@nod.at>
	 <1306910297.3359.49.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Jun 2011 11:13:41 +0200
Message-ID: <1306919621.2353.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 23:38 -0700, John Stultz wrote:
> On Sun, 2011-05-29 at 12:48 +0200, Richard Weinberger wrote:
> > The alarmtimer interface makes IMHO only sense when a RTC device
> > is available.
> > On systems with !CONFIG_RTC_CLASS (like UML) the warning
> > "Kernel not built with RTC support, ALARM timers will not wake from suspend"
> > is annoying.
> 
> Yea. 
> 
> The tradeoff with this patch is that applications that use
> CLOCK_REALTIME_ALARM or CLOCK_BOOTTIME_ALARM will then get -EINVAL.
> 
> I'm mixed here, since we probably want to communicate to the application
> that the alarm timers aren't going to wake us up, but also I suspect
> most applications won't handle the -EINVAL properly, so I had allowed
> for the clockids to still work as long as we didn't suspend.
> 
> I'm leaning more towards just returning EINVAL as you suggest, since
> really the functionality isn't there. But I'm thinking possibly doing so
> if no RTCs are detected at runtime (rather then using all the ifdefs you
> do).
> 
> Thoughts from anyone else?

Wouldn't -ENOTSUPP be a better return value than -EINVAL? But yeah, I
think simply returning an error is fine, if apps don't check for that,
they're broken, simple as that, we can't possibly avoid all userspace
problems by adding more kernel code.
