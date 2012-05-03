Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2ECT5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:57:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40259 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab2ECT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:57:49 -0400
Message-ID: <4FA2E334.7040601@linaro.org>
Date: Thu, 03 May 2012 12:57:40 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050319-2398-0000-0000-00000655A555
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:12 AM, Richard Cochran wrote:
> Just in time for this year's leap second, this patch series presents a
> solution for the UTC leap second mess.
>
> Of course, the POSIX UTC system is broken by design, and the Linux
> kernel cannot fix that. However, what we can do is correctly execute
> leap seconds and always report the time variables (UTC time, TAI
> offset, and leap second status) with consistency.
>
> The basic idea is to keep the internal time using a continuous
> timescale and to convert to UTC by testing the time value against the
> current threshold and adding the appropriate offset. Since the UTC
> time and the leap second status is provided on demand, this eliminates
> the need to set a timer or to constantly monitor for leap seconds, as
> was done up until now.

So as I mentioned in my earlier review of this patch set, I'm not as 
excited about the meta-layer you added in utc-tai.h.

So I figured I'd give it a short go and see if a good chunk of what your 
proposing could be done in a simpler way.

Please check out:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/clktai

The untested patch set there basically pushes TAI time management into 
the timekeeping core, and then exports a CLOCK_TAI clockid.

This patch set *does not* address the tick-granularity delayed 
leap-second processing issue that your patch also addresses. But I feel 
like the basic handling of tai is a little simpler.

Take a look at it and let me know what you think.
thanks
-john

