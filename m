Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2BKHka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 02:40:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47981 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2BKHkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 02:40:02 -0500
Date: Sat, 11 Feb 2012 08:39:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
Message-ID: <20120211073947.GA2446@netboy.at.omicron.at>
References: <4F32A347.4090703@linaro.org>
 <20120209051218.GC2211@netboy.at.omicron.at>
 <4F33910D.2030409@linaro.org>
 <20120209184019.GA2217@netboy.at.omicron.at>
 <4F341F40.3020806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F341F40.3020806@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 11:32:16AM -0800, Dmitry Antipov wrote:
> On 02/09/2012 10:40 AM, Richard Cochran wrote:
> 
> >I thought this list was about Linux kernel development, but now it
> >seems to be about Sun's old bugs.
> 
> This Sun (probably) has ~100000x more accurate hrtimers than it's said,
> and it's a bug. My panda board (with 32K timer enabled) has ~30000x
> less accurate hrtimers than it's said, and it's not a bug. Great.

If I understand you correctly, what you are looking for is a way to
get a promise from the OS regarding a real time deadlines, right?
But that is a different question than the timer unit resolution:

Q: What is the finest timer duration that I may request?
A: One nanosecond (answer by getres).

Q: What kind of real time deadline will my system provide?
A: Nobody knows for sure.

Just because the OS claims timer resolution X does mean that your
application can assume, "okay, I'll just set my periodic task at
duration X and the OS will take care of the rest." The only thing the
user can count on is that the timer expiration will not come _before_
the deadline. The nanosleep man page puts its like this:

   If the interval specified in req is not an exact multiple of the
   granularity underlying clock (see time(7)), then the interval will
   be rounded up to the next multiple.  Furthermore, after the sleep
   completes, there may still be a delay before the CPU becomes free
   to once again execute the calling thread.

I agree that getres does not provide very useful information. Under
Linux, it merely indicates the present of high resolution timer
support.

The practical solution to what you are asking for is overall system
testing tuning, and this is unfortunately manual labor.

Richard
