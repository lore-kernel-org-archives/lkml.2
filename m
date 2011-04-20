Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DTGei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:34:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1DTGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X75+i30LUJ098Usdqxr0OEEqi4oV9jqV7UO8/zNbjIkUkuZEyMCAyGSh3/fEUlOWar
         69ApTMmRbuPc0L6YtPK0o1gVOG76qTXrVTedkXVnqGujJ26/iKJkQ4QztNK/xGkzB9Rn
         iZ1OQBoMlVX2zMvgBubm1IcH3GDvZCYivJ8VY=
Date: Wed, 20 Apr 2011 08:34:26 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 4/4] timers: posix interface for alarm-timers
Message-ID: <20110420063426.GB20952@riccoc20.at.omicron.at>
References: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
 <1303257510-15054-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303257510-15054-5-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 04:58:30PM -0700, John Stultz wrote:
> This patch exposes alarm-timers to userland via the posix clock
> and timers interface, using two new clockids: CLOCK_REALTIME_ALARM
> and CLOCK_BOOTTIME_ALARM. Both clockids behave identically to
> CLOCK_REALTIME and CLOCK_BOOTTIME, respectively, but timers
> set against the _ALARM suffixed clockids will wake the system if
> it is suspended.

So, is there reason these cannot or should not be using the dynamic
posix clock interface?

> The semantics of the Android alarm driver are different from what
> this posix interface provides.
...
> One potential way to implement similar semantics may be via
> the timerfd infrastructure, but this needs more research.
> 
> There may also need to be some sort of sysfs system level policy
> hooks that allow alarm timers to be disabled to keep them
> from firing at inappropriate times (ie: laptop in a well insulated
> bag, mid-flight).

I have not put hardly any thought into these issues, but the dynamic
interface gives you a character device at no extra charge.

Richard
