Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162990Ab2GLX7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:59:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39190 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161882Ab2GLX7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:59:33 -0400
Message-ID: <4FFF64A8.8040504@us.ibm.com>
Date: Thu, 12 Jul 2012 16:58:32 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Bohac <jbohac@suse.cz>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <4FFCB287.80701@us.ibm.com> <20120712224334.GA32620@midget.suse.cz>
In-Reply-To: <20120712224334.GA32620@midget.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071223-2398-0000-0000-00000874C265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 03:43 PM, Jiri Bohac wrote:
> On Tue, Jul 10, 2012 at 03:53:59PM -0700, John Stultz wrote:
>> On 07/10/2012 03:43 PM, John Stultz wrote:
>>> Over the weekend, Thomas got a chance to review the leap second fix
>>> in more detail and had a few additional changes he wanted to make
>>> to improve performance as well as style.
>>>
>>> So this iteration includes his modifications.
>>>
>>> Once merged, I'll be working to get the backports finished as quickly
>>> as I can and sent to -stable.
> looking at the proposed 2.6.32.y stable patch at:
> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=18d208632bf17aed56c581b882868b2be44be71e;hp=6d224606bb8eec78027522d6dd5abfea8108c41a
> Is this the final version you are about to send to -stable?
No, this isn't what I'm sending to -stable.  That was my backport that 
was done was prior to merging Thomas' modifications from over the 
weekend. Having, so far, done this backporting 3 times or so,  I figured 
I'd just wait until something got committed upstream before trying to 
backport it again. :)


> In 2.6.32 timekeeping_leap_insert() is not called from the timer
> interrupt, but from the leap_timer hrtimer.
>
> I think the new clock_was_set_timer will thus not be called by
> irq_exit() because TIMER_SOFTIRQ has not been raised. Unless
> TIMER_SOFTIRQ is raised, clock_was_set() will not be called until
> the next periodic timer interrupt, correct?
>
> Wouldn't the original schedule_work() approach work better for
> 2.6.32?
>
> Or do you plan backporting the most recent version to 2.6.32?

I'll be backporting & testing the most recent version once it is 
committed upstream.

thanks
-john

