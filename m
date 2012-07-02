Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2GBTIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:08:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60087 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GBTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:08:45 -0400
Message-ID: <4FF1F193.3000707@us.ibm.com>
Date: Mon, 02 Jul 2012 12:08:03 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com> <4FF11FCB.4030207@us.ibm.com> <20120702185103.GA32257@redhat.com>
In-Reply-To: <20120702185103.GA32257@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070219-7408-0000-0000-0000066A3A8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 11:51 AM, Dave Jones wrote:
> On Sun, Jul 01, 2012 at 09:12:59PM -0700, John Stultz wrote:
>   > On 07/01/2012 11:29 AM, John Stultz wrote:
>   > > TODOs:
>   > > * Chase down the futex/hrtimer interaction to see if this could
>   > > be triggered in any other way.
>   > > * Get Tglx's input/ack
>   > > * Generate a backport for pre-v3.4 kernels
>   > So while still waiting for feedback on the clock_was_set() change, I
>   > went ahead and generated backports for most of the stable kernels on
>   > kernel.org.
>   >
>   > Clearly these shouldn't go anywhere until the fix is upstream, but since
>   > I assume there's a number of distro developers who are likely under
>   > pressure to have a fix soon, I wanted to make them available so no one
>   > is duplicating work.
>   >
>   > You can find them here:
>   > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=summary
>   >
>   > I did boot and test each of those kernels with my leaptest-timer.c test
>   > successfully.
>
> I'm curious how the test that I did with the kernel patch,
> or Richard Cochran's userspace test program didn't trigger this bug
> when we tested last week.

It likely did trigger the issue.

> any ideas what we missed ?

In order to observe this issue, you need to notice that CLOCK_REALTIME 
timers are firing one second early.  The issue does not affect 
CLOCK_MONOTONIC timers.  Its only most visible with applications that 
make sub-second CLOCK_REALTIME timeouts in a loop (most reported cases 
connected with futexs). So if such an application wasn't running, it 
would be easy to overlook.

thanks
-john

