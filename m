Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1FVJTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:19:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35380 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1FVJTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PciXg/LYPoYxzj8WZQ6Rs3TkkHnW9zmJnLWbKMxoFzZq+nnAutxOlpIcMRSAIOMLM2
         +iQAmN0qr2xn3swYGCKZurVv8SvyIqIYFxelUJbX7gGN0LRnBJCHHpkVn+vbjyjOMTcw
         67Kxx/hllSZ1+KwuNG7SIWllrjn0iZFZR2qyQ=
MIME-Version: 1.0
In-Reply-To: <1308700373-18415-3-git-send-email-john.stultz@linaro.org>
References: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
	<1308700373-18415-3-git-send-email-john.stultz@linaro.org>
Date: Wed, 22 Jun 2011 11:19:05 +0200
Message-ID: <BANLkTinEgRe6GgPv=WwvNmCsmWjkupRqwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] alarmtimers: Return -ENOTSUPP if no RTC device is present
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/22 John Stultz <john.stultz@linaro.org>:
> Toralf Förster and Richard Weinberger noted that if there is
> no RTC device, the alarm timers core prints out an annoying
> "ALARM timers will not wake from suspend" message.
>
> This warning has been removed in a previous patch, however
> the issue still remains:  The original idea was to support
> alarm timers even if there was no rtc device, as long as the
> system didn't go into suspend.
>
> However, after further consideration, communicating to the application
> that alarmtimers are not fully functional seems like the better
> solution.
>
> So this patch makes it so we return -ENOTSUPP to any posix _ALARM
> clockid calls if there is no backing RTC device on the system.
>
> Further this changes the behavior where when there is no rtc device
> we will check for one on clock_getres, clock_gettime, timer_create,
> and timer_nsleep instead of on suspend.
>
> CC: Toralf Förster <toralf.foerster@gmx.de>
> CC: Richard Weinberger <richard@nod.at

Ahhh, the missing ">" explains why I didn't receive this mail. :-)

-- 
Thanks,
//richard
